import streamlit as st # docs.streamlit.io/
import pandas as pd # [Python library] Create a DataFrame (like a spreadsheet) 
import altair as alt # [Python library] More declarative statistical visualization library for Python
from queries.get_data import get_customer_full_view # import SQL View

st.set_page_config(page_title="Riyadh Project Dashboard", layout="wide")

st.title("Customer Full View (Joined Tables)")
st.markdown("This dashboard shows all customers, managers, and financial data joined from your PostgreSQL view.")

df = get_customer_full_view()

if df.empty:
    st.warning("No data found in the view.")
else:
    st.dataframe(df, use_container_width=True)

    if "business" in df.columns and "revenue" in df.columns:
        df["revenue"] = pd.to_numeric(df["revenue"], errors="coerce")
        filtered_df = df[["business", "revenue"]].dropna()
        business_revenue = (
            filtered_df.groupby("business", as_index=False)["revenue"]
            .sum()
            .sort_values("revenue", ascending=False)
            .head(4)
        )

        st.subheader("Q4 Revenue by Business")

        bar_chart = alt.Chart(business_revenue).mark_bar().encode(
            x=alt.X("business:N", sort="-y", axis=alt.Axis(labelAngle=-45)),
            y=alt.Y("revenue:Q"),
            tooltip=["business", "revenue"]
        ).properties(
            width=600,
            height=400
        )

        st.altair_chart(bar_chart, use_container_width=True)
    else:
        st.error("The required columns 'business' or 'revenue' were not found in the data.")
