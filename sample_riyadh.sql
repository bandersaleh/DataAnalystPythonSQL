--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-07-29 04:34:23

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
-- TOC entry 226 (class 1255 OID 16411)
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
-- TOC entry 227 (class 1255 OID 16428)
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
-- TOC entry 220 (class 1259 OID 16399)
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
-- TOC entry 219 (class 1259 OID 16398)
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
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 219
-- Name: customer_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_data_id_seq OWNED BY public.customer_data.id;


--
-- TOC entry 221 (class 1259 OID 16405)
-- Name: finance_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.finance_data (
    llc_id integer NOT NULL,
    date date,
    revenue numeric(12,2)
);


ALTER TABLE public.finance_data OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16420)
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
-- TOC entry 224 (class 1259 OID 16429)
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
-- TOC entry 225 (class 1259 OID 16434)
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
-- TOC entry 222 (class 1259 OID 16419)
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
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 222
-- Name: manager_data_manager_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manager_data_manager_id_seq OWNED BY public.manager_data.manager_id;


--
-- TOC entry 218 (class 1259 OID 16390)
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
-- TOC entry 217 (class 1259 OID 16389)
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
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 217
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- TOC entry 4666 (class 2604 OID 16402)
-- Name: customer_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_data ALTER COLUMN id SET DEFAULT nextval('public.customer_data_id_seq'::regclass);


--
-- TOC entry 4667 (class 2604 OID 16423)
-- Name: manager_data manager_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager_data ALTER COLUMN manager_id SET DEFAULT nextval('public.manager_data_manager_id_seq'::regclass);


--
-- TOC entry 4665 (class 2604 OID 16393)
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- TOC entry 4826 (class 0 OID 16399)
-- Dependencies: 220
-- Data for Name: customer_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_data (id, username, user_email, llc_id, business, manager_id) FROM stdin;
1	John Doe	johndoe@email.com	9877	Alexa	201
2	Jane Doe	janedoe@email.com	6400	Airbnb	201
3	Alex Wilson	alexwilson@email.com	4101	Twitch	201
4	Kate Hansen	khansen@email.com	3501	Whole Foods Market	201
\.


--
-- TOC entry 4827 (class 0 OID 16405)
-- Dependencies: 221
-- Data for Name: finance_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.finance_data (llc_id, date, revenue) FROM stdin;
9877	2023-03-31	91000.00
6400	2023-06-30	62000.00
4101	2023-09-30	43300.00
3501	2023-12-31	1200.00
\.


--
-- TOC entry 4829 (class 0 OID 16420)
-- Dependencies: 223
-- Data for Name: manager_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manager_data (manager_id, fname, lname, city, state, country, zipcode) FROM stdin;
201	Jeff	Bezos	Seattle	Washington	United States of America	98109
\.


--
-- TOC entry 4824 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, name, description, location, goal) FROM stdin;
1	Green Riyadh Phase 1	Planting 7.5 million trees...	Riyadh	Enhance air quality and reduce heat
\.


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 219
-- Name: customer_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_data_id_seq', 4, true);


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 222
-- Name: manager_data_manager_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manager_data_manager_id_seq', 1, false);


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 217
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- TOC entry 4671 (class 2606 OID 16404)
-- Name: customer_data customer_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_data
    ADD CONSTRAINT customer_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4673 (class 2606 OID 16409)
-- Name: finance_data finance_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.finance_data
    ADD CONSTRAINT finance_data_pkey PRIMARY KEY (llc_id);


--
-- TOC entry 4675 (class 2606 OID 16427)
-- Name: manager_data manager_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manager_data
    ADD CONSTRAINT manager_data_pkey PRIMARY KEY (manager_id);


--
-- TOC entry 4669 (class 2606 OID 16397)
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


-- Completed on 2025-07-29 04:34:23

--
-- PostgreSQL database dump complete
--

