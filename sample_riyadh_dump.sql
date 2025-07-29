--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: get_all_projects(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_projects() RETURNS TABLE(id integer, name character varying, description text, location character varying, goal character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT id, name, description, location, goal
    FROM projects;
END;
$$;


ALTER FUNCTION public.get_all_projects() OWNER TO postgres;

--
-- Name: get_full_customer_finance_manager_view(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_full_customer_finance_manager_view() RETURNS TABLE(customer_id integer, username character varying, user_email character varying, business character varying, llc_id integer, revenue numeric, revenue_date date, manager_id integer, manager_fname character varying, manager_lname character varying, manager_city character varying, manager_state character varying, manager_country character varying, manager_zipcode character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS customer_id,
        c.username,
        c.user_email,
        c.business,
        c.llc_id,
        f.revenue,
        f.date AS revenue_date,
        m.manager_id,
        m.fname AS manager_fname,
        m.lname AS manager_lname,
        m.city AS manager_city,
        m.state AS manager_state,
        m.country AS manager_country,
        m.zipcode AS manager_zipcode
    FROM customer_data c
    LEFT JOIN finance_data f ON c.llc_id = f.llc_id
    LEFT JOIN manager_data m ON c.manager_id = m.manager_id;
END;
$$;


ALTER FUNCTION public.get_full_customer_finance_manager_view() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_data (
    id integer NOT NULL,
    username character varying(100),
    user_email character varying(100),
    llc_id integer,
    business character varying(255),
    manager_id integer
);


ALTER TABLE public.customer_data OWNER TO postgres;

--
-- Name: customer_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_data_id_seq OWNER TO postgres;

--
-- Name: customer_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_data_id_seq OWNED BY public.customer_data.id;


--
-- Name: finance_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finance_data (
    llc_id integer NOT NULL,
    date date,
    revenue numeric(12,2)
);


ALTER TABLE public.finance_data OWNER TO postgres;

--
-- Name: manager_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manager_data (
    manager_id integer NOT NULL,
    fname character varying(100),
    lname character varying(100),
    city character varying(100),
    state character varying(100),
    country character varying(100),
    zipcode character varying(20)
);


ALTER TABLE public.manager_data OWNER TO postgres;

--
-- Name: customer_full_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.customer_full_view AS
 SELECT c.id AS customer_id,
    c.username,
    c.user_email,
    c.business,
    c.llc_id,
    f.revenue,
    f.date AS revenue_date,
    m.manager_id,
    m.fname AS manager_fname,
    m.lname AS manager_lname,
    m.city AS manager_city,
    m.state AS manager_state,
    m.country AS manager_country,
    m.zipcode AS manager_zipcode
   FROM ((public.customer_data c
     LEFT JOIN public.finance_data f ON ((c.llc_id = f.llc_id)))
     LEFT JOIN public.manager_data m ON ((c.manager_id = m.manager_id)));


ALTER VIEW public.customer_full_view OWNER TO postgres;

--
-- Name: low_revenue_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.low_revenue_view AS
 SELECT c.id AS customer_id,
    c.username,
    c.user_email,
    c.business,
    c.llc_id,
    f.date AS revenue_date,
    f.revenue,
    c.manager_id,
    m.fname AS manager_fname,
    m.lname AS manager_lname,
    m.city,
    m.state,
    m.country,
    m.zipcode
   FROM ((public.customer_data c
     LEFT JOIN public.finance_data f ON ((c.llc_id = f.llc_id)))
     LEFT JOIN public.manager_data m ON ((c.manager_id = m.manager_id)))
  WHERE (f.revenue < (2000)::numeric);


ALTER VIEW public.low_revenue_view OWNER TO postgres;

--
-- Name: manager_data_manager_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manager_data_manager_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manager_data_manager_id_seq OWNER TO postgres;

--
-- Name: manager_data_manager_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manager_data_manager_id_seq OWNED BY public.manager_data.manager_id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(255),
    description text,
    location character varying(255),
    goal character varying(255)
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: customer_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_data ALTER COLUMN id SET DEFAULT nextval('public.customer_data_id_seq'::regclass);


--
-- Name: manager_data manager_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager_data ALTER COLUMN manager_id SET DEFAULT nextval('public.manager_data_manager_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Data for Name: customer_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_data (id, username, user_email, llc_id, business, manager_id) FROM stdin;
1	John Doe	johndoe@email.com	9877	Alexa	201
2	Jane Doe	janedoe@email.com	6400	Airbnb	201
3	Alex Wilson	alexwilson@email.com	4101	Twitch	201
4	Kate Hansen	khansen@email.com	3501	Whole Foods Market	201
\.


--
-- Data for Name: finance_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.finance_data (llc_id, date, revenue) FROM stdin;
9877	2023-03-31	91000.00
6400	2023-06-30	62000.00
4101	2023-09-30	43300.00
3501	2023-12-31	1200.00
\.


--
-- Data for Name: manager_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager_data (manager_id, fname, lname, city, state, country, zipcode) FROM stdin;
201	Jeff	Bezos	Seattle	Washington	United States of America	98109
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, description, location, goal) FROM stdin;
1	Green Riyadh Phase 1	Planting 7.5 million trees...	Riyadh	Enhance air quality and reduce heat
\.


--
-- Name: customer_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_data_id_seq', 4, true);


--
-- Name: manager_data_manager_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manager_data_manager_id_seq', 1, false);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- Name: customer_data customer_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_data
    ADD CONSTRAINT customer_data_pkey PRIMARY KEY (id);


--
-- Name: finance_data finance_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finance_data
    ADD CONSTRAINT finance_data_pkey PRIMARY KEY (llc_id);


--
-- Name: manager_data manager_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager_data
    ADD CONSTRAINT manager_data_pkey PRIMARY KEY (manager_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

