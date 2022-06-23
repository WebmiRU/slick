--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)

-- Started on 2022-06-23 18:01:12 MSK

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3020 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 16385)
-- Name: channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.channel (
    id bigint NOT NULL,
    title character varying
);


ALTER TABLE public.channel OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 16391)
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
-- TOC entry 3021 (class 0 OID 0)
-- Dependencies: 203
-- Name: channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.channel_id_seq OWNED BY public.channel.id;


--
-- TOC entry 204 (class 1259 OID 16399)
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
-- TOC entry 205 (class 1259 OID 16405)
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
-- TOC entry 3022 (class 0 OID 0)
-- Dependencies: 205
-- Name: message_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_channel_id_seq OWNED BY public.message_channel.id;


--
-- TOC entry 211 (class 1259 OID 16474)
-- Name: private_message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.private_message (
    sender_id bigint,
    receiver_id bigint
);


ALTER TABLE public.private_message OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16409)
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
-- TOC entry 207 (class 1259 OID 16415)
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
-- TOC entry 3023 (class 0 OID 0)
-- Dependencies: 207
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 208 (class 1259 OID 16417)
-- Name: user_m2m_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_m2m_channel (
    id bigint NOT NULL,
    user_id bigint,
    channel_id bigint
);


ALTER TABLE public.user_m2m_channel OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16420)
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
-- TOC entry 3024 (class 0 OID 0)
-- Dependencies: 209
-- Name: user_m2m_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_m2m_channel_id_seq OWNED BY public.user_m2m_channel.id;


--
-- TOC entry 210 (class 1259 OID 16422)
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
-- TOC entry 2863 (class 2604 OID 16426)
-- Name: channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel ALTER COLUMN id SET DEFAULT nextval('public.channel_id_seq'::regclass);


--
-- TOC entry 2864 (class 2604 OID 16428)
-- Name: message_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel ALTER COLUMN id SET DEFAULT nextval('public.message_channel_id_seq'::regclass);


--
-- TOC entry 2865 (class 2604 OID 16429)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2866 (class 2604 OID 16430)
-- Name: user_m2m_channel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel ALTER COLUMN id SET DEFAULT nextval('public.user_m2m_channel_id_seq'::regclass);


--
-- TOC entry 3006 (class 0 OID 16385)
-- Dependencies: 202
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
-- TOC entry 3008 (class 0 OID 16399)
-- Dependencies: 204
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
-- TOC entry 3014 (class 0 OID 16474)
-- Dependencies: 211
-- Data for Name: private_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.private_message (sender_id, receiver_id) FROM stdin;
\.


--
-- TOC entry 3010 (class 0 OID 16409)
-- Dependencies: 206
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, login, password, token, nick) FROM stdin;
1	user1	password1	51e8a6109f115d9f6c39d4e0d134f0363fec3335cff5081a6d39ac85007c9215	User-1
2	user2	password2	token2	USER-2
3	user3	\N	token3	USER-3
\.


--
-- TOC entry 3012 (class 0 OID 16417)
-- Dependencies: 208
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
-- TOC entry 3025 (class 0 OID 0)
-- Dependencies: 203
-- Name: channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.channel_id_seq', 8, true);


--
-- TOC entry 3026 (class 0 OID 0)
-- Dependencies: 205
-- Name: message_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_channel_id_seq', 10, true);


--
-- TOC entry 3027 (class 0 OID 0)
-- Dependencies: 207
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- TOC entry 3028 (class 0 OID 0)
-- Dependencies: 209
-- Name: user_m2m_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_m2m_channel_id_seq', 7, true);


--
-- TOC entry 2868 (class 2606 OID 16432)
-- Name: channel channel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT channel_pk PRIMARY KEY (id);


--
-- TOC entry 2870 (class 2606 OID 16434)
-- Name: message_channel message_channel_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_pk PRIMARY KEY (id);


--
-- TOC entry 2872 (class 2606 OID 16438)
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- TOC entry 2877 (class 2606 OID 16477)
-- Name: private_message fk_private_message_receiver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_message
    ADD CONSTRAINT fk_private_message_receiver FOREIGN KEY (receiver_id) REFERENCES public."user"(id);


--
-- TOC entry 2878 (class 2606 OID 16482)
-- Name: private_message fk_private_message_sender; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_message
    ADD CONSTRAINT fk_private_message_sender FOREIGN KEY (sender_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2873 (class 2606 OID 16439)
-- Name: message_channel message_channel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_fk FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2874 (class 2606 OID 16444)
-- Name: message_channel message_channel_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_channel
    ADD CONSTRAINT message_channel_fk_1 FOREIGN KEY (channel_id) REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2875 (class 2606 OID 16459)
-- Name: user_m2m_channel user_m2m_channel_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel
    ADD CONSTRAINT user_m2m_channel_fk FOREIGN KEY (user_id) REFERENCES public."user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2876 (class 2606 OID 16464)
-- Name: user_m2m_channel user_m2m_channel_fk2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_m2m_channel
    ADD CONSTRAINT user_m2m_channel_fk2 FOREIGN KEY (channel_id) REFERENCES public.channel(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2022-06-23 18:01:13 MSK

--
-- PostgreSQL database dump complete
--

