--
-- PostgreSQL database dump
--

-- Dumped from database version 15beta1
-- Dumped by pg_dump version 15beta1

-- Started on 2022-06-11 19:52:47

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE slick;
--
-- TOC entry 3374 (class 1262 OID 16398)
-- Name: slick; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE slick WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';


ALTER DATABASE slick OWNER TO postgres;

\connect slick

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16418)
-- Name: channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel (
    id bigint NOT NULL,
    title character varying
);


ALTER TABLE public.channel OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16417)
-- Name: channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.channel_id_seq OWNER TO postgres;

--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 218
-- Name: channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_id_seq OWNED BY public.channel.id;


--
-- TOC entry 217 (class 1259 OID 16407)
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id bigint NOT NULL,
    text character varying,
    user_id bigint,
    channel_id bigint
);


ALTER TABLE public.message OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16461)
-- Name: message_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_channel (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    channel_id bigint NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE public.message_channel OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16460)
-- Name: message_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_channel_id_seq OWNER TO postgres;

--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 223
-- Name: message_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_channel_id_seq OWNED BY public.message_channel.id;


--
-- TOC entry 216 (class 1259 OID 16406)
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_seq OWNER TO postgres;

--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 216
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- TOC entry 215 (class 1259 OID 16400)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    login character varying NOT NULL,
    password character varying,
    token character varying,
    nick character varying
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16399)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 214
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 221 (class 1259 OID 16425)
-- Name: user_m2m_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_m2m_channel (
    id bigint NOT NULL,
    user_id bigint,
    channel_id bigint
);


ALTER TABLE public.user_m2m_channel OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16424)
-- Name: user_m2m_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_m2m_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_m2m_channel_id_seq OWNER TO postgres;

--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_m2m_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_m2m_channel_id_seq OWNED BY public.user_m2m_channel.id;


--
-- TOC entry 222 (class 1259 OID 16446)
-- Name: view_user_channel; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_user_channel AS
 SELECT "user".id AS user_id,
    channel.id,
    channel.title
   FROM ((public.user_m2m_channel
     LEFT JOIN public."user" ON (("user".id = user_m2m_channel.user_id)))
     LEFT JOIN public.channel ON ((channel.id = user_m2m_channel.channel_id)));


ALTER TABLE public.view_user_channel OWNER TO postgres;

--
-- TOC entry 3199 (class 2604 OID 16421)
-- Name: channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel ALTER COLUMN id SET DEFAULT nextval('public.channel_id_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 16410)
-- Name: message id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- TOC entry 3201 (class 2604 OID 16464)
-- Name: message_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel ALTER COLUMN id SET DEFAULT nextval('public.message_channel_id_seq'::regclass);


--
-- TOC entry 3197 (class 2604 OID 16403)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 3200 (class 2604 OID 16428)
-- Name: user_m2m_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel ALTER COLUMN id SET DEFAULT nextval('public.user_m2m_channel_id_seq'::regclass);


--
-- TOC entry 3364 (class 0 OID 16418)
-- Dependencies: 219
-- Data for Name: channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.channel (id, title) FROM stdin;
1	Channel 1
2	Channel 2
3	Channel 3
4	Channel 4
5	Channel 5
6	Channel 6
7	Channel 7
\.


--
-- TOC entry 3362 (class 0 OID 16407)
-- Dependencies: 217
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (id, text, user_id, channel_id) FROM stdin;
1	Message 1	1	1
2	Message 2	1	1
3	Message 3	2	1
\.


--
-- TOC entry 3368 (class 0 OID 16461)
-- Dependencies: 224
-- Data for Name: message_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message_channel (id, user_id, channel_id, value) FROM stdin;
1	1	1	Message 1-1
2	1	1	Message 1-2
3	1	1	Message 1-3
4	1	1	Message 1-4
5	1	1	Message 1-5
6	1	1	Message 1-6
7	1	1	Message 1-7
8	1	2	Message 2-1
9	1	2	Message 2-2
10	1	2	Message 2-3
\.


--
-- TOC entry 3360 (class 0 OID 16400)
-- Dependencies: 215
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, login, password, token, nick) FROM stdin;
1	user1	password1	51e8a6109f115d9f6c39d4e0d134f0363fec3335cff5081a6d39ac85007c9215	User-1
2	user2	password2	token2	USER-2
3	user3	\N	token3	USER-3
\.


--
-- TOC entry 3366 (class 0 OID 16425)
-- Dependencies: 221
-- Data for Name: user_m2m_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_m2m_channel (id, user_id, channel_id) FROM stdin;
1	1	1
2	1	2
3	1	5
4	1	7
5	1	4
6	2	1
7	2	2
\.


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 218
-- Name: channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.channel_id_seq', 7, true);


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 223
-- Name: message_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_channel_id_seq', 10, true);


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 216
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_id_seq', 3, true);


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 214
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 220
-- Name: user_m2m_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_m2m_channel_id_seq', 7, true);


--
-- TOC entry 3207 (class 2606 OID 16435)
-- Name: channel channel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT channel_pk PRIMARY KEY (id);


--
-- TOC entry 3209 (class 2606 OID 16468)
-- Name: message_channel message_channel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_pk PRIMARY KEY (id);


--
-- TOC entry 3205 (class 2606 OID 16416)
-- Name: message message_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pk PRIMARY KEY (id);


--
-- TOC entry 3203 (class 2606 OID 16414)
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 16469)
-- Name: message_channel message_channel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_fk FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3215 (class 2606 OID 16474)
-- Name: message_channel message_channel_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_fk_1 FOREIGN KEY (channel_id) REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3210 (class 2606 OID 16450)
-- Name: message message_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_fk FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3211 (class 2606 OID 16455)
-- Name: message message_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_fk_1 FOREIGN KEY (channel_id) REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3212 (class 2606 OID 16441)
-- Name: user_m2m_channel user_m2m_channel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel
    ADD CONSTRAINT user_m2m_channel_fk FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3213 (class 2606 OID 16436)
-- Name: user_m2m_channel user_m2m_channel_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel
    ADD CONSTRAINT user_m2m_channel_fk2 FOREIGN KEY (channel_id) REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-06-11 19:52:47

--
-- PostgreSQL database dump complete
--

