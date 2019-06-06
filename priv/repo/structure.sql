--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matches (
    id bigint NOT NULL,
    division character varying(255),
    season character varying(255),
    match_date date,
    home_team character varying(255),
    away_team character varying(255),
    fthg integer,
    ftag integer,
    ftr character varying(1),
    hthg integer,
    htag integer,
    htr character varying(1)
);


--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: results; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.results AS
 WITH home_matches AS (
         SELECT matches.division,
            matches.season,
            matches.home_team AS team,
            count(matches.id) AS played,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'H'::text)) AS win,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'D'::text)) AS draw,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'A'::text)) AS lose,
            sum(matches.fthg) AS goals_for,
            sum(matches.ftag) AS goals_againts
           FROM public.matches
          GROUP BY matches.division, matches.season, matches.home_team
        ), away_matches AS (
         SELECT matches.division,
            matches.season,
            matches.away_team AS team,
            count(matches.id) AS played,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'A'::text)) AS win,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'D'::text)) AS draw,
            count(matches.id) FILTER (WHERE ((matches.ftr)::text = 'H'::text)) AS lose,
            sum(matches.ftag) AS goals_for,
            sum(matches.fthg) AS goals_againts
           FROM public.matches
          GROUP BY matches.division, matches.season, matches.away_team
        )
 SELECT all_matches.division,
    all_matches.season,
    all_matches.team,
    sum((all_matches.played)::integer) AS played,
    sum((all_matches.win)::integer) AS win,
    sum((all_matches.draw)::integer) AS draw,
    sum((all_matches.lose)::integer) AS lose,
    sum((all_matches.goals_for)::integer) AS goals_for,
    sum((all_matches.goals_againts)::integer) AS goals_againts,
    (sum((all_matches.goals_for)::integer) - sum((all_matches.goals_againts)::integer)) AS goals_diffs,
    ((sum((all_matches.win)::integer) * 3) + sum((all_matches.draw)::integer)) AS points
   FROM ( SELECT home_matches.division,
            home_matches.season,
            home_matches.team,
            home_matches.played,
            home_matches.win,
            home_matches.draw,
            home_matches.lose,
            home_matches.goals_for,
            home_matches.goals_againts
           FROM home_matches
        UNION
         SELECT away_matches.division,
            away_matches.season,
            away_matches.team,
            away_matches.played,
            away_matches.win,
            away_matches.draw,
            away_matches.lose,
            away_matches.goals_for,
            away_matches.goals_againts
           FROM away_matches) all_matches
  GROUP BY all_matches.division, all_matches.season, all_matches.team
  ORDER BY ((sum((all_matches.win)::integer) * 3) + sum((all_matches.draw)::integer)) DESC, (sum((all_matches.goals_for)::integer)) DESC;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matches (id, division, season, match_date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr) FROM stdin;
1	SP1	201617	2016-08-19	La Coruna	Eibar	2	1	H	0	0	D
2	SP1	201617	2016-08-19	Malaga	Osasuna	1	1	D	0	0	D
3	SP1	201617	2016-08-20	Barcelona	Betis	6	2	H	3	1	H
4	SP1	201617	2016-08-20	Granada	Villarreal	1	1	D	0	0	D
5	SP1	201617	2016-08-20	Sevilla	Espanol	6	4	H	3	3	D
6	SP1	201617	2016-08-21	Ath Madrid	Alaves	1	1	D	0	0	D
7	SP1	201617	2016-08-21	Sociedad	Real Madrid	0	3	A	0	2	A
8	SP1	201617	2016-08-21	Sp Gijon	Ath Bilbao	2	1	H	0	0	D
9	SP1	201617	2016-08-22	Celta	Leganes	0	1	A	0	0	D
10	SP1	201617	2016-08-22	Valencia	Las Palmas	2	4	A	2	3	A
11	SP1	201617	2016-08-26	Betis	La Coruna	0	0	D	0	0	D
12	SP1	201617	2016-08-26	Espanol	Malaga	2	2	D	1	0	H
14	SP1	201617	2016-08-27	Leganes	Ath Madrid	0	0	D	0	0	D
15	SP1	201617	2016-08-27	Osasuna	Sociedad	0	2	A	0	1	A
16	SP1	201617	2016-08-27	Real Madrid	Celta	2	1	H	0	0	D
17	SP1	201617	2016-08-28	Alaves	Sp Gijon	0	0	D	0	0	D
18	SP1	201617	2016-08-28	Ath Bilbao	Barcelona	0	1	A	0	1	A
19	SP1	201617	2016-08-28	Las Palmas	Granada	5	1	H	1	1	D
20	SP1	201617	2016-08-28	Villarreal	Sevilla	0	0	D	0	0	D
21	SP1	201617	2016-09-09	Sociedad	Espanol	1	1	D	0	0	D
22	SP1	201617	2016-09-10	Barcelona	Alaves	1	2	A	0	1	A
23	SP1	201617	2016-09-10	Celta	Ath Madrid	0	4	A	0	0	D
24	SP1	201617	2016-09-10	Malaga	Villarreal	0	2	A	0	2	A
25	SP1	201617	2016-09-10	Real Madrid	Osasuna	5	2	H	3	0	H
26	SP1	201617	2016-09-10	Sevilla	Las Palmas	2	1	H	0	1	A
27	SP1	201617	2016-09-11	Granada	Eibar	1	2	A	0	1	A
28	SP1	201617	2016-09-11	La Coruna	Ath Bilbao	0	1	A	0	1	A
29	SP1	201617	2016-09-11	Sp Gijon	Leganes	2	1	H	2	0	H
30	SP1	201617	2016-09-11	Valencia	Betis	2	3	A	0	1	A
31	SP1	201617	2016-09-16	Betis	Granada	2	2	D	1	2	A
32	SP1	201617	2016-09-17	Ath Madrid	Sp Gijon	5	0	H	3	0	H
34	SP1	201617	2016-09-17	Las Palmas	Malaga	1	0	H	1	0	H
35	SP1	201617	2016-09-17	Leganes	Barcelona	1	5	A	0	3	A
36	SP1	201617	2016-09-18	Ath Bilbao	Valencia	2	1	H	2	1	H
37	SP1	201617	2016-09-18	Espanol	Real Madrid	0	2	A	0	1	A
38	SP1	201617	2016-09-18	Osasuna	Celta	0	0	D	0	0	D
39	SP1	201617	2016-09-18	Villarreal	Sociedad	2	1	H	2	1	H
40	SP1	201617	2016-09-19	Alaves	La Coruna	0	0	D	0	0	D
41	SP1	201617	2016-09-20	Malaga	Eibar	2	1	H	1	1	D
42	SP1	201617	2016-09-20	Sevilla	Betis	1	0	H	0	0	D
43	SP1	201617	2016-09-21	Barcelona	Ath Madrid	1	1	D	1	0	H
44	SP1	201617	2016-09-21	Celta	Sp Gijon	2	1	H	0	0	D
45	SP1	201617	2016-09-21	Granada	Ath Bilbao	1	2	A	1	1	D
46	SP1	201617	2016-09-21	Real Madrid	Villarreal	1	1	D	0	1	A
47	SP1	201617	2016-09-21	Sociedad	Las Palmas	4	1	H	3	0	H
48	SP1	201617	2016-09-22	La Coruna	Leganes	1	2	A	1	0	H
49	SP1	201617	2016-09-22	Osasuna	Espanol	1	2	A	0	1	A
50	SP1	201617	2016-09-22	Valencia	Alaves	2	1	H	1	1	D
51	SP1	201617	2016-09-23	Betis	Malaga	1	0	H	1	0	H
52	SP1	201617	2016-09-24	Ath Bilbao	Sevilla	3	1	H	1	0	H
54	SP1	201617	2016-09-24	Las Palmas	Real Madrid	2	2	D	1	1	D
55	SP1	201617	2016-09-24	Sp Gijon	Barcelona	0	5	A	0	2	A
56	SP1	201617	2016-09-25	Ath Madrid	La Coruna	1	0	H	0	0	D
57	SP1	201617	2016-09-25	Espanol	Celta	0	2	A	0	0	D
58	SP1	201617	2016-09-25	Leganes	Valencia	1	2	A	1	1	D
59	SP1	201617	2016-09-25	Villarreal	Osasuna	3	1	H	3	1	H
60	SP1	201617	2016-09-26	Alaves	Granada	3	1	H	0	0	D
61	SP1	201617	2016-09-30	Sociedad	Betis	1	0	H	0	0	D
62	SP1	201617	2016-10-01	Granada	Leganes	0	1	A	0	0	D
63	SP1	201617	2016-10-01	La Coruna	Sp Gijon	2	1	H	1	0	H
64	SP1	201617	2016-10-01	Osasuna	Las Palmas	2	2	D	2	0	H
65	SP1	201617	2016-10-01	Sevilla	Alaves	2	1	H	0	0	D
66	SP1	201617	2016-10-02	Celta	Barcelona	4	3	H	3	0	H
67	SP1	201617	2016-10-02	Espanol	Villarreal	0	0	D	0	0	D
68	SP1	201617	2016-10-02	Malaga	Ath Bilbao	2	1	H	0	1	A
69	SP1	201617	2016-10-02	Real Madrid	Eibar	1	1	D	1	1	D
70	SP1	201617	2016-10-02	Valencia	Ath Madrid	0	2	A	0	0	D
71	SP1	201617	2016-10-14	Las Palmas	Espanol	0	0	D	0	0	D
72	SP1	201617	2016-10-15	Ath Madrid	Granada	7	1	H	2	1	H
73	SP1	201617	2016-10-15	Barcelona	La Coruna	4	0	H	3	0	H
74	SP1	201617	2016-10-15	Betis	Real Madrid	1	6	A	0	4	A
75	SP1	201617	2016-10-15	Leganes	Sevilla	2	3	A	0	1	A
76	SP1	201617	2016-10-16	Alaves	Malaga	1	1	D	1	0	H
77	SP1	201617	2016-10-16	Ath Bilbao	Sociedad	3	2	H	0	1	A
78	SP1	201617	2016-10-16	Sp Gijon	Valencia	1	2	A	1	1	D
79	SP1	201617	2016-10-16	Villarreal	Celta	5	0	H	3	0	H
81	SP1	201617	2016-10-21	Osasuna	Betis	1	2	A	0	1	A
82	SP1	201617	2016-10-22	Espanol	Eibar	3	3	D	0	3	A
83	SP1	201617	2016-10-22	Granada	Sp Gijon	0	0	D	0	0	D
84	SP1	201617	2016-10-22	Sociedad	Alaves	3	0	H	1	0	H
85	SP1	201617	2016-10-22	Valencia	Barcelona	2	3	A	0	1	A
86	SP1	201617	2016-10-23	Celta	La Coruna	4	1	H	1	1	D
87	SP1	201617	2016-10-23	Malaga	Leganes	4	0	H	2	0	H
88	SP1	201617	2016-10-23	Real Madrid	Ath Bilbao	2	1	H	1	1	D
89	SP1	201617	2016-10-23	Sevilla	Ath Madrid	1	0	H	0	0	D
90	SP1	201617	2016-10-23	Villarreal	Las Palmas	2	1	H	0	1	A
91	SP1	201617	2016-10-28	Leganes	Sociedad	0	2	A	0	1	A
92	SP1	201617	2016-10-29	Alaves	Real Madrid	1	4	A	1	2	A
93	SP1	201617	2016-10-29	Ath Madrid	Malaga	4	2	H	3	1	H
94	SP1	201617	2016-10-29	Barcelona	Granada	1	0	H	0	0	D
95	SP1	201617	2016-10-29	Sp Gijon	Sevilla	1	1	D	1	1	D
96	SP1	201617	2016-10-30	Ath Bilbao	Osasuna	1	1	D	1	1	D
97	SP1	201617	2016-10-30	Betis	Espanol	0	1	A	0	0	D
99	SP1	201617	2016-10-30	Las Palmas	Celta	3	3	D	0	3	A
100	SP1	201617	2016-10-31	La Coruna	Valencia	1	1	D	1	0	H
101	SP1	201617	2016-11-04	Malaga	Sp Gijon	3	2	H	1	1	D
102	SP1	201617	2016-11-05	Granada	La Coruna	1	1	D	0	0	D
103	SP1	201617	2016-11-05	Las Palmas	Eibar	1	0	H	0	0	D
104	SP1	201617	2016-11-05	Osasuna	Alaves	0	1	A	0	0	D
105	SP1	201617	2016-11-05	Sociedad	Ath Madrid	2	0	H	0	0	D
106	SP1	201617	2016-11-06	Celta	Valencia	2	1	H	1	1	D
107	SP1	201617	2016-11-06	Espanol	Ath Bilbao	0	0	D	0	0	D
108	SP1	201617	2016-11-06	Real Madrid	Leganes	3	0	H	2	0	H
109	SP1	201617	2016-11-06	Sevilla	Barcelona	1	2	A	1	1	D
110	SP1	201617	2016-11-06	Villarreal	Betis	2	0	H	1	0	H
111	SP1	201617	2016-11-18	Betis	Las Palmas	2	0	H	2	0	H
112	SP1	201617	2016-11-19	Ath Madrid	Real Madrid	0	3	A	0	1	A
113	SP1	201617	2016-11-19	Barcelona	Malaga	0	0	D	0	0	D
115	SP1	201617	2016-11-19	La Coruna	Sevilla	2	3	A	2	1	H
116	SP1	201617	2016-11-20	Alaves	Espanol	0	1	A	0	0	D
117	SP1	201617	2016-11-20	Ath Bilbao	Villarreal	1	0	H	0	0	D
118	SP1	201617	2016-11-20	Sp Gijon	Sociedad	1	3	A	1	1	D
119	SP1	201617	2016-11-20	Valencia	Granada	1	1	D	0	1	A
120	SP1	201617	2016-11-21	Leganes	Osasuna	2	0	H	1	0	H
122	SP1	201617	2016-11-26	Espanol	Leganes	3	0	H	0	0	D
123	SP1	201617	2016-11-26	Malaga	La Coruna	4	3	H	2	1	H
124	SP1	201617	2016-11-26	Real Madrid	Sp Gijon	2	1	H	2	1	H
125	SP1	201617	2016-11-26	Sevilla	Valencia	2	1	H	0	0	D
126	SP1	201617	2016-11-27	Celta	Granada	3	1	H	2	0	H
127	SP1	201617	2016-11-27	Osasuna	Ath Madrid	0	3	A	0	2	A
128	SP1	201617	2016-11-27	Sociedad	Barcelona	1	1	D	0	0	D
129	SP1	201617	2016-11-27	Villarreal	Alaves	0	2	A	0	2	A
130	SP1	201617	2016-11-28	Las Palmas	Ath Bilbao	3	1	H	1	0	H
131	SP1	201617	2016-12-03	Ath Madrid	Espanol	0	0	D	0	0	D
132	SP1	201617	2016-12-03	Barcelona	Real Madrid	1	1	D	0	0	D
133	SP1	201617	2016-12-03	Granada	Sevilla	2	1	H	1	0	H
134	SP1	201617	2016-12-03	Leganes	Villarreal	0	0	D	0	0	D
135	SP1	201617	2016-12-04	Alaves	Las Palmas	1	1	D	1	0	H
136	SP1	201617	2016-12-04	Ath Bilbao	Eibar	3	1	H	1	0	H
137	SP1	201617	2016-12-04	Betis	Celta	3	3	D	1	1	D
138	SP1	201617	2016-12-04	Sp Gijon	Osasuna	3	1	H	1	0	H
139	SP1	201617	2016-12-04	Valencia	Malaga	2	2	D	2	1	H
140	SP1	201617	2016-12-05	La Coruna	Sociedad	5	1	H	3	0	H
141	SP1	201617	2016-12-09	Malaga	Granada	1	1	D	1	0	H
142	SP1	201617	2016-12-10	Las Palmas	Leganes	1	1	D	1	0	H
143	SP1	201617	2016-12-10	Osasuna	Barcelona	0	3	A	0	0	D
144	SP1	201617	2016-12-10	Real Madrid	La Coruna	3	2	H	0	0	D
145	SP1	201617	2016-12-10	Sociedad	Valencia	3	2	H	2	1	H
146	SP1	201617	2016-12-11	Betis	Ath Bilbao	1	0	H	1	0	H
147	SP1	201617	2016-12-11	Celta	Sevilla	0	3	A	0	0	D
149	SP1	201617	2016-12-11	Espanol	Sp Gijon	2	1	H	0	0	D
150	SP1	201617	2016-12-12	Villarreal	Ath Madrid	3	0	H	2	0	H
151	SP1	201617	2016-12-16	Alaves	Betis	1	0	H	0	0	D
152	SP1	201617	2016-12-17	Ath Madrid	Las Palmas	1	0	H	0	0	D
153	SP1	201617	2016-12-17	Granada	Sociedad	0	2	A	0	0	D
154	SP1	201617	2016-12-17	Sevilla	Malaga	4	1	H	4	0	H
155	SP1	201617	2016-12-17	Sp Gijon	Villarreal	1	3	A	0	2	A
156	SP1	201617	2016-12-18	Barcelona	Espanol	4	1	H	1	0	H
157	SP1	201617	2016-12-18	La Coruna	Osasuna	2	0	H	2	0	H
158	SP1	201617	2016-12-18	Leganes	Eibar	1	1	D	1	0	H
159	SP1	201617	2016-12-19	Ath Bilbao	Celta	2	1	H	0	0	D
160	SP1	201617	2017-01-06	Espanol	La Coruna	1	1	D	0	0	D
162	SP1	201617	2017-01-07	Las Palmas	Sp Gijon	1	0	H	0	0	D
163	SP1	201617	2017-01-07	Real Madrid	Granada	5	0	H	4	0	H
164	SP1	201617	2017-01-07	Sociedad	Sevilla	0	4	A	0	2	A
165	SP1	201617	2017-01-08	Ath Bilbao	Alaves	0	0	D	0	0	D
166	SP1	201617	2017-01-08	Betis	Leganes	2	0	H	0	0	D
167	SP1	201617	2017-01-08	Celta	Malaga	3	1	H	1	0	H
168	SP1	201617	2017-01-08	Villarreal	Barcelona	1	1	D	0	0	D
169	SP1	201617	2017-01-09	Osasuna	Valencia	3	3	D	1	2	A
170	SP1	201617	2017-01-14	Ath Madrid	Betis	1	0	H	1	0	H
171	SP1	201617	2017-01-14	Barcelona	Las Palmas	5	0	H	1	0	H
172	SP1	201617	2017-01-14	La Coruna	Villarreal	0	0	D	0	0	D
173	SP1	201617	2017-01-14	Leganes	Ath Bilbao	0	0	D	0	0	D
174	SP1	201617	2017-01-15	Celta	Alaves	1	0	H	0	0	D
175	SP1	201617	2017-01-15	Granada	Osasuna	1	1	D	0	1	A
176	SP1	201617	2017-01-15	Sevilla	Real Madrid	2	1	H	0	0	D
177	SP1	201617	2017-01-15	Sp Gijon	Eibar	2	3	A	1	3	A
178	SP1	201617	2017-01-15	Valencia	Espanol	2	1	H	1	0	H
179	SP1	201617	2017-01-16	Malaga	Sociedad	0	2	A	0	0	D
180	SP1	201617	2017-01-20	Las Palmas	La Coruna	1	1	D	1	0	H
181	SP1	201617	2017-01-21	Alaves	Leganes	2	2	D	1	1	D
182	SP1	201617	2017-01-21	Espanol	Granada	3	1	H	2	1	H
183	SP1	201617	2017-01-21	Real Madrid	Malaga	2	1	H	2	0	H
184	SP1	201617	2017-01-21	Villarreal	Valencia	0	2	A	0	2	A
185	SP1	201617	2017-01-22	Ath Bilbao	Ath Madrid	2	2	D	1	1	D
186	SP1	201617	2017-01-22	Betis	Sp Gijon	0	0	D	0	0	D
188	SP1	201617	2017-01-22	Osasuna	Sevilla	3	4	A	1	1	D
189	SP1	201617	2017-01-22	Sociedad	Celta	1	0	H	0	0	D
190	SP1	201617	2017-01-27	Osasuna	Malaga	1	1	D	0	0	D
191	SP1	201617	2017-01-28	Alaves	Ath Madrid	0	0	D	0	0	D
193	SP1	201617	2017-01-28	Leganes	Celta	0	2	A	0	1	A
194	SP1	201617	2017-01-28	Villarreal	Granada	2	0	H	1	0	H
195	SP1	201617	2017-01-29	Ath Bilbao	Sp Gijon	2	1	H	0	1	A
196	SP1	201617	2017-01-29	Betis	Barcelona	1	1	D	0	0	D
197	SP1	201617	2017-01-29	Espanol	Sevilla	3	1	H	2	1	H
198	SP1	201617	2017-01-29	Real Madrid	Sociedad	3	0	H	1	0	H
199	SP1	201617	2017-01-30	Las Palmas	Valencia	3	1	H	1	1	D
200	SP1	201617	2017-02-04	Ath Madrid	Leganes	2	0	H	1	0	H
201	SP1	201617	2017-02-04	Barcelona	Ath Bilbao	3	0	H	2	0	H
202	SP1	201617	2017-02-04	Malaga	Espanol	0	1	A	0	1	A
203	SP1	201617	2017-02-04	Valencia	Eibar	0	4	A	0	2	A
204	SP1	201617	2017-02-05	Sevilla	Villarreal	0	0	D	0	0	D
205	SP1	201617	2017-02-05	Sociedad	Osasuna	3	2	H	0	1	A
206	SP1	201617	2017-02-05	Sp Gijon	Alaves	2	4	A	0	1	A
207	SP1	201617	2017-02-06	Granada	Las Palmas	1	0	H	1	0	H
208	SP1	201617	2017-02-10	Espanol	Sociedad	1	2	A	1	1	D
209	SP1	201617	2017-02-11	Alaves	Barcelona	0	6	A	0	2	A
210	SP1	201617	2017-02-11	Ath Bilbao	La Coruna	2	1	H	0	1	A
211	SP1	201617	2017-02-11	Betis	Valencia	0	0	D	0	0	D
212	SP1	201617	2017-02-11	Osasuna	Real Madrid	1	3	A	1	1	D
213	SP1	201617	2017-02-12	Ath Madrid	Celta	3	2	H	1	1	D
214	SP1	201617	2017-02-12	Las Palmas	Sevilla	0	1	A	0	0	D
215	SP1	201617	2017-02-12	Leganes	Sp Gijon	0	2	A	0	0	D
216	SP1	201617	2017-02-12	Villarreal	Malaga	1	1	D	0	1	A
218	SP1	201617	2017-02-17	Granada	Betis	4	1	H	3	0	H
219	SP1	201617	2017-02-18	La Coruna	Alaves	0	1	A	0	0	D
220	SP1	201617	2017-02-18	Real Madrid	Espanol	2	0	H	1	0	H
221	SP1	201617	2017-02-18	Sevilla	Eibar	2	0	H	1	0	H
222	SP1	201617	2017-02-18	Sp Gijon	Ath Madrid	1	4	A	0	0	D
223	SP1	201617	2017-02-19	Barcelona	Leganes	2	1	H	1	0	H
224	SP1	201617	2017-02-19	Celta	Osasuna	3	0	H	1	0	H
225	SP1	201617	2017-02-19	Sociedad	Villarreal	0	1	A	0	0	D
226	SP1	201617	2017-02-19	Valencia	Ath Bilbao	2	0	H	2	0	H
227	SP1	201617	2017-02-20	Malaga	Las Palmas	2	1	H	2	1	H
228	SP1	201617	2017-02-22	Valencia	Real Madrid	2	1	H	2	1	H
229	SP1	201617	2017-02-24	Las Palmas	Sociedad	0	1	A	0	0	D
230	SP1	201617	2017-02-25	Alaves	Valencia	2	1	H	0	0	D
231	SP1	201617	2017-02-25	Betis	Sevilla	1	2	A	1	0	H
233	SP1	201617	2017-02-25	Leganes	La Coruna	4	0	H	2	0	H
234	SP1	201617	2017-02-26	Ath Bilbao	Granada	3	1	H	2	1	H
235	SP1	201617	2017-02-26	Ath Madrid	Barcelona	1	2	A	0	0	D
236	SP1	201617	2017-02-26	Espanol	Osasuna	3	0	H	1	0	H
237	SP1	201617	2017-02-26	Sp Gijon	Celta	1	1	D	0	0	D
238	SP1	201617	2017-02-26	Villarreal	Real Madrid	2	3	A	0	0	D
239	SP1	201617	2017-02-28	Malaga	Betis	1	2	A	1	0	H
240	SP1	201617	2017-02-28	Sociedad	Eibar	2	2	D	1	1	D
241	SP1	201617	2017-02-28	Valencia	Leganes	1	0	H	1	0	H
242	SP1	201617	2017-03-01	Barcelona	Sp Gijon	6	1	H	3	1	H
243	SP1	201617	2017-03-01	Celta	Espanol	2	2	D	2	2	D
244	SP1	201617	2017-03-01	Granada	Alaves	2	1	H	1	0	H
245	SP1	201617	2017-03-01	Osasuna	Villarreal	1	4	A	0	2	A
246	SP1	201617	2017-03-01	Real Madrid	Las Palmas	3	3	D	1	1	D
247	SP1	201617	2017-03-02	La Coruna	Ath Madrid	1	1	D	1	0	H
248	SP1	201617	2017-03-02	Sevilla	Ath Bilbao	1	0	H	1	0	H
249	SP1	201617	2017-03-03	Betis	Sociedad	2	3	A	1	2	A
250	SP1	201617	2017-03-04	Barcelona	Celta	5	0	H	2	0	H
252	SP1	201617	2017-03-04	Leganes	Granada	1	0	H	0	0	D
253	SP1	201617	2017-03-04	Villarreal	Espanol	2	0	H	1	0	H
254	SP1	201617	2017-03-05	Ath Bilbao	Malaga	1	0	H	0	0	D
255	SP1	201617	2017-03-05	Ath Madrid	Valencia	3	0	H	1	0	H
256	SP1	201617	2017-03-05	Las Palmas	Osasuna	5	2	H	1	2	A
257	SP1	201617	2017-03-05	Sp Gijon	La Coruna	0	1	A	0	1	A
258	SP1	201617	2017-03-06	Alaves	Sevilla	1	1	D	0	1	A
259	SP1	201617	2017-03-08	La Coruna	Betis	1	1	D	0	0	D
260	SP1	201617	2017-03-10	Espanol	Las Palmas	4	3	H	2	1	H
261	SP1	201617	2017-03-11	Granada	Ath Madrid	0	1	A	0	0	D
262	SP1	201617	2017-03-11	Malaga	Alaves	1	2	A	0	1	A
263	SP1	201617	2017-03-11	Sevilla	Leganes	1	1	D	1	1	D
264	SP1	201617	2017-03-11	Valencia	Sp Gijon	1	1	D	0	0	D
265	SP1	201617	2017-03-12	Celta	Villarreal	0	1	A	0	1	A
266	SP1	201617	2017-03-12	La Coruna	Barcelona	2	1	H	1	0	H
267	SP1	201617	2017-03-12	Real Madrid	Betis	2	1	H	1	1	D
268	SP1	201617	2017-03-12	Sociedad	Ath Bilbao	0	2	A	0	1	A
269	SP1	201617	2017-03-13	Osasuna	Eibar	1	1	D	0	0	D
270	SP1	201617	2017-03-17	Las Palmas	Villarreal	1	0	H	1	0	H
271	SP1	201617	2017-03-18	Alaves	Sociedad	1	0	H	1	0	H
272	SP1	201617	2017-03-18	Ath Bilbao	Real Madrid	1	2	A	0	1	A
273	SP1	201617	2017-03-18	Betis	Osasuna	2	0	H	2	0	H
275	SP1	201617	2017-03-19	Ath Madrid	Sevilla	3	1	H	1	0	H
276	SP1	201617	2017-03-19	Barcelona	Valencia	4	2	H	2	2	D
277	SP1	201617	2017-03-19	La Coruna	Celta	0	1	A	0	0	D
278	SP1	201617	2017-03-19	Leganes	Malaga	0	0	D	0	0	D
279	SP1	201617	2017-03-19	Sp Gijon	Granada	3	1	H	0	0	D
280	SP1	201617	2017-03-31	Espanol	Betis	2	1	H	0	0	D
281	SP1	201617	2017-04-01	Malaga	Ath Madrid	0	2	A	0	1	A
282	SP1	201617	2017-04-01	Osasuna	Ath Bilbao	1	2	A	0	2	A
283	SP1	201617	2017-04-01	Sociedad	Leganes	1	1	D	0	1	A
284	SP1	201617	2017-04-01	Villarreal	Eibar	2	3	A	1	0	H
285	SP1	201617	2017-04-02	Granada	Barcelona	1	4	A	0	1	A
286	SP1	201617	2017-04-02	Real Madrid	Alaves	3	0	H	1	0	H
287	SP1	201617	2017-04-02	Sevilla	Sp Gijon	0	0	D	0	0	D
288	SP1	201617	2017-04-02	Valencia	La Coruna	3	0	H	2	0	H
289	SP1	201617	2017-04-03	Celta	Las Palmas	3	1	H	2	0	H
290	SP1	201617	2017-04-04	Ath Bilbao	Espanol	2	0	H	2	0	H
291	SP1	201617	2017-04-04	Ath Madrid	Sociedad	1	0	H	1	0	H
292	SP1	201617	2017-04-04	Betis	Villarreal	0	1	A	0	0	D
293	SP1	201617	2017-04-05	Alaves	Osasuna	0	1	A	0	0	D
294	SP1	201617	2017-04-05	Barcelona	Sevilla	3	0	H	3	0	H
295	SP1	201617	2017-04-05	La Coruna	Granada	0	0	D	0	0	D
296	SP1	201617	2017-04-05	Leganes	Real Madrid	2	4	A	2	3	A
297	SP1	201617	2017-04-05	Sp Gijon	Malaga	0	1	A	0	1	A
299	SP1	201617	2017-04-06	Valencia	Celta	3	2	H	1	1	D
300	SP1	201617	2017-04-07	Villarreal	Ath Bilbao	3	1	H	1	1	D
301	SP1	201617	2017-04-08	Espanol	Alaves	1	0	H	0	0	D
302	SP1	201617	2017-04-08	Malaga	Barcelona	2	0	H	1	0	H
303	SP1	201617	2017-04-08	Real Madrid	Ath Madrid	1	1	D	0	0	D
304	SP1	201617	2017-04-08	Sevilla	La Coruna	4	2	H	3	2	H
305	SP1	201617	2017-04-09	Celta	Eibar	0	2	A	0	1	A
306	SP1	201617	2017-04-09	Granada	Valencia	1	3	A	0	2	A
307	SP1	201617	2017-04-09	Las Palmas	Betis	4	1	H	1	0	H
308	SP1	201617	2017-04-09	Osasuna	Leganes	2	1	H	1	1	D
309	SP1	201617	2017-04-10	Sociedad	Sp Gijon	3	1	H	2	0	H
310	SP1	201617	2017-04-14	Ath Bilbao	Las Palmas	5	1	H	3	1	H
311	SP1	201617	2017-04-15	Ath Madrid	Osasuna	3	0	H	1	0	H
312	SP1	201617	2017-04-15	Barcelona	Sociedad	3	2	H	3	2	H
313	SP1	201617	2017-04-15	La Coruna	Malaga	2	0	H	0	0	D
314	SP1	201617	2017-04-15	Sp Gijon	Real Madrid	2	3	A	1	1	D
315	SP1	201617	2017-04-16	Betis	Eibar	2	0	H	1	0	H
316	SP1	201617	2017-04-16	Granada	Celta	0	3	A	0	1	A
317	SP1	201617	2017-04-16	Leganes	Espanol	0	1	A	0	0	D
318	SP1	201617	2017-04-16	Valencia	Sevilla	0	0	D	0	0	D
319	SP1	201617	2017-04-17	Alaves	Villarreal	2	1	H	2	0	H
320	SP1	201617	2017-04-21	Sevilla	Granada	2	0	H	1	0	H
321	SP1	201617	2017-04-22	Espanol	Ath Madrid	0	1	A	0	0	D
322	SP1	201617	2017-04-22	Malaga	Valencia	2	0	H	2	0	H
323	SP1	201617	2017-04-22	Osasuna	Sp Gijon	2	2	D	1	0	H
324	SP1	201617	2017-04-22	Villarreal	Leganes	2	1	H	0	0	D
325	SP1	201617	2017-04-23	Celta	Betis	0	1	A	0	0	D
326	SP1	201617	2017-04-23	Las Palmas	Alaves	1	1	D	1	0	H
327	SP1	201617	2017-04-23	Real Madrid	Barcelona	2	3	A	1	1	D
328	SP1	201617	2017-04-23	Sociedad	La Coruna	1	0	H	1	0	H
330	SP1	201617	2017-04-25	Ath Madrid	Villarreal	0	1	A	0	0	D
331	SP1	201617	2017-04-25	Granada	Malaga	0	2	A	0	0	D
332	SP1	201617	2017-04-25	Sp Gijon	Espanol	1	1	D	1	0	H
333	SP1	201617	2017-04-26	Barcelona	Osasuna	7	1	H	2	0	H
334	SP1	201617	2017-04-26	La Coruna	Real Madrid	2	6	A	1	3	A
335	SP1	201617	2017-04-26	Leganes	Las Palmas	3	0	H	0	0	D
336	SP1	201617	2017-04-26	Valencia	Sociedad	2	3	A	0	2	A
337	SP1	201617	2017-04-27	Alaves	Eibar	0	0	D	0	0	D
338	SP1	201617	2017-04-27	Ath Bilbao	Betis	2	1	H	0	0	D
339	SP1	201617	2017-04-27	Sevilla	Celta	2	1	H	0	0	D
340	SP1	201617	2017-04-28	Villarreal	Sp Gijon	3	1	H	1	0	H
341	SP1	201617	2017-04-29	Espanol	Barcelona	0	3	A	0	0	D
342	SP1	201617	2017-04-29	Las Palmas	Ath Madrid	0	5	A	0	3	A
343	SP1	201617	2017-04-29	Real Madrid	Valencia	2	1	H	1	0	H
344	SP1	201617	2017-04-29	Sociedad	Granada	2	1	H	1	0	H
345	SP1	201617	2017-04-30	Betis	Alaves	1	4	A	1	0	H
346	SP1	201617	2017-04-30	Celta	Ath Bilbao	0	3	A	0	1	A
348	SP1	201617	2017-04-30	Osasuna	La Coruna	2	2	D	1	1	D
349	SP1	201617	2017-05-01	Malaga	Sevilla	4	2	H	1	1	D
350	SP1	201617	2017-05-05	Sevilla	Sociedad	1	1	D	1	0	H
351	SP1	201617	2017-05-06	Ath Madrid	Eibar	1	0	H	0	0	D
352	SP1	201617	2017-05-06	Barcelona	Villarreal	4	1	H	2	1	H
353	SP1	201617	2017-05-06	Granada	Real Madrid	0	4	A	0	4	A
354	SP1	201617	2017-05-06	Sp Gijon	Las Palmas	1	0	H	0	0	D
355	SP1	201617	2017-05-07	Alaves	Ath Bilbao	1	0	H	0	0	D
356	SP1	201617	2017-05-07	La Coruna	Espanol	1	2	A	0	2	A
357	SP1	201617	2017-05-07	Malaga	Celta	3	0	H	1	0	H
358	SP1	201617	2017-05-07	Valencia	Osasuna	4	1	H	2	0	H
359	SP1	201617	2017-05-08	Leganes	Betis	4	0	H	2	0	H
360	SP1	201617	2017-05-13	Espanol	Valencia	0	1	A	0	0	D
361	SP1	201617	2017-05-13	Osasuna	Granada	2	1	H	1	1	D
362	SP1	201617	2017-05-14	Alaves	Celta	3	1	H	3	0	H
363	SP1	201617	2017-05-14	Ath Bilbao	Leganes	1	1	D	1	0	H
364	SP1	201617	2017-05-14	Betis	Ath Madrid	1	1	D	0	0	D
366	SP1	201617	2017-05-14	Las Palmas	Barcelona	1	4	A	0	2	A
367	SP1	201617	2017-05-14	Real Madrid	Sevilla	4	1	H	2	0	H
368	SP1	201617	2017-05-14	Sociedad	Malaga	2	2	D	1	1	D
369	SP1	201617	2017-05-14	Villarreal	La Coruna	0	0	D	0	0	D
370	SP1	201617	2017-05-17	Celta	Real Madrid	1	4	A	0	1	A
371	SP1	201617	2017-05-19	Granada	Espanol	1	2	A	1	2	A
372	SP1	201617	2017-05-20	La Coruna	Las Palmas	3	0	H	3	0	H
373	SP1	201617	2017-05-20	Leganes	Alaves	1	1	D	0	0	D
374	SP1	201617	2017-05-20	Sevilla	Osasuna	5	0	H	3	0	H
375	SP1	201617	2017-05-20	Sp Gijon	Betis	2	2	D	1	1	D
376	SP1	201617	2017-05-21	Ath Madrid	Ath Bilbao	3	1	H	2	0	H
377	SP1	201617	2017-05-21	Barcelona	Eibar	4	2	H	0	1	A
378	SP1	201617	2017-05-21	Celta	Sociedad	2	2	D	0	0	D
379	SP1	201617	2017-05-21	Malaga	Real Madrid	0	2	A	0	1	A
380	SP1	201617	2017-05-21	Valencia	Villarreal	1	3	A	0	1	A
381	SP1	201516	2015-08-21	Malaga	Sevilla	0	0	D	0	0	D
382	SP1	201516	2015-08-22	Ath Madrid	Las Palmas	1	0	H	1	0	H
383	SP1	201516	2015-08-22	Espanol	Getafe	1	0	H	1	0	H
384	SP1	201516	2015-08-22	La Coruna	Sociedad	0	0	D	0	0	D
385	SP1	201516	2015-08-22	Vallecano	Valencia	0	0	D	0	0	D
386	SP1	201516	2015-08-23	Ath Bilbao	Barcelona	0	1	A	0	0	D
387	SP1	201516	2015-08-23	Betis	Villarreal	1	1	D	0	1	A
388	SP1	201516	2015-08-23	Levante	Celta	1	2	A	0	1	A
389	SP1	201516	2015-08-23	Sp Gijon	Real Madrid	0	0	D	0	0	D
390	SP1	201516	2015-08-24	Granada	Eibar	1	3	A	0	2	A
391	SP1	201516	2015-08-28	Villarreal	Espanol	3	1	H	0	1	A
392	SP1	201516	2015-08-29	Barcelona	Malaga	1	0	H	0	0	D
393	SP1	201516	2015-08-29	Celta	Vallecano	3	0	H	1	0	H
394	SP1	201516	2015-08-29	Real Madrid	Betis	5	0	H	2	0	H
395	SP1	201516	2015-08-29	Sociedad	Sp Gijon	0	0	D	0	0	D
397	SP1	201516	2015-08-30	Getafe	Granada	1	2	A	0	2	A
398	SP1	201516	2015-08-30	Las Palmas	Levante	0	0	D	0	0	D
399	SP1	201516	2015-08-30	Sevilla	Ath Madrid	0	3	A	0	1	A
400	SP1	201516	2015-08-30	Valencia	La Coruna	1	1	D	1	1	D
401	SP1	201516	2015-09-11	Levante	Sevilla	1	1	D	0	1	A
402	SP1	201516	2015-09-12	Ath Madrid	Barcelona	1	2	A	0	0	D
403	SP1	201516	2015-09-12	Betis	Sociedad	1	0	H	1	0	H
404	SP1	201516	2015-09-12	Espanol	Real Madrid	0	6	A	0	4	A
405	SP1	201516	2015-09-12	Sp Gijon	Valencia	0	1	A	0	0	D
406	SP1	201516	2015-09-13	Ath Bilbao	Getafe	3	1	H	2	0	H
407	SP1	201516	2015-09-13	Celta	Las Palmas	3	3	D	2	1	H
408	SP1	201516	2015-09-13	Granada	Villarreal	1	3	A	0	0	D
409	SP1	201516	2015-09-13	Malaga	Eibar	0	0	D	0	0	D
410	SP1	201516	2015-09-14	Vallecano	La Coruna	1	3	A	1	2	A
411	SP1	201516	2015-09-18	Getafe	Malaga	1	0	H	1	0	H
413	SP1	201516	2015-09-19	Real Madrid	Granada	1	0	H	0	0	D
414	SP1	201516	2015-09-19	Sociedad	Espanol	2	3	A	1	1	D
415	SP1	201516	2015-09-19	Valencia	Betis	0	0	D	0	0	D
416	SP1	201516	2015-09-20	Barcelona	Levante	4	1	H	0	0	D
417	SP1	201516	2015-09-20	La Coruna	Sp Gijon	2	3	A	2	3	A
347	SP1	201617	2017-04-30	Eibar	Leganes	2	0	H	0	0	D
418	SP1	201516	2015-09-20	Las Palmas	Vallecano	0	1	A	0	1	A
419	SP1	201516	2015-09-20	Sevilla	Celta	1	2	A	0	2	A
420	SP1	201516	2015-09-20	Villarreal	Ath Bilbao	3	1	H	1	0	H
421	SP1	201516	2015-09-22	Ath Madrid	Getafe	2	0	H	1	0	H
422	SP1	201516	2015-09-22	Espanol	Valencia	1	0	H	1	0	H
423	SP1	201516	2015-09-22	Granada	Sociedad	0	3	A	0	2	A
424	SP1	201516	2015-09-23	Ath Bilbao	Real Madrid	1	2	A	0	1	A
425	SP1	201516	2015-09-23	Celta	Barcelona	4	1	H	2	0	H
426	SP1	201516	2015-09-23	Las Palmas	Sevilla	2	0	H	1	0	H
427	SP1	201516	2015-09-23	Levante	Eibar	2	2	D	0	1	A
428	SP1	201516	2015-09-23	Malaga	Villarreal	0	1	A	0	0	D
429	SP1	201516	2015-09-23	Vallecano	Sp Gijon	2	1	H	1	0	H
430	SP1	201516	2015-09-24	Betis	La Coruna	1	2	A	0	0	D
431	SP1	201516	2015-09-25	Valencia	Granada	1	0	H	1	0	H
432	SP1	201516	2015-09-26	Barcelona	Las Palmas	2	1	H	1	0	H
434	SP1	201516	2015-09-26	Real Madrid	Malaga	0	0	D	0	0	D
435	SP1	201516	2015-09-26	Sevilla	Vallecano	3	2	H	2	0	H
436	SP1	201516	2015-09-26	Villarreal	Ath Madrid	1	0	H	1	0	H
437	SP1	201516	2015-09-27	Getafe	Levante	3	0	H	0	0	D
438	SP1	201516	2015-09-27	La Coruna	Espanol	3	0	H	2	0	H
439	SP1	201516	2015-09-27	Sociedad	Ath Bilbao	0	0	D	0	0	D
440	SP1	201516	2015-09-27	Sp Gijon	Betis	1	2	A	1	0	H
441	SP1	201516	2015-10-02	Celta	Getafe	0	0	D	0	0	D
442	SP1	201516	2015-10-03	Espanol	Sp Gijon	1	2	A	0	1	A
443	SP1	201516	2015-10-03	Granada	La Coruna	1	1	D	0	1	A
444	SP1	201516	2015-10-03	Las Palmas	Eibar	0	2	A	0	1	A
445	SP1	201516	2015-10-03	Malaga	Sociedad	3	1	H	2	1	H
446	SP1	201516	2015-10-03	Sevilla	Barcelona	2	1	H	0	0	D
447	SP1	201516	2015-10-04	Ath Bilbao	Valencia	3	1	H	1	1	D
448	SP1	201516	2015-10-04	Ath Madrid	Real Madrid	1	1	D	0	1	A
449	SP1	201516	2015-10-04	Levante	Villarreal	1	0	H	0	0	D
450	SP1	201516	2015-10-04	Vallecano	Betis	0	2	A	0	1	A
451	SP1	201516	2015-10-17	Barcelona	Vallecano	5	2	H	2	1	H
452	SP1	201516	2015-10-17	Betis	Espanol	1	3	A	0	1	A
454	SP1	201516	2015-10-17	Real Madrid	Levante	3	0	H	2	0	H
455	SP1	201516	2015-10-17	Valencia	Malaga	3	0	H	2	0	H
456	SP1	201516	2015-10-18	Getafe	Las Palmas	4	0	H	2	0	H
457	SP1	201516	2015-10-18	La Coruna	Ath Bilbao	2	2	D	0	1	A
458	SP1	201516	2015-10-18	Sociedad	Ath Madrid	0	2	A	0	1	A
459	SP1	201516	2015-10-18	Villarreal	Celta	1	2	A	0	1	A
460	SP1	201516	2015-10-19	Sp Gijon	Granada	3	3	D	1	2	A
461	SP1	201516	2015-10-23	Vallecano	Espanol	3	0	H	1	0	H
462	SP1	201516	2015-10-24	Celta	Real Madrid	1	3	A	0	2	A
463	SP1	201516	2015-10-24	Granada	Betis	1	1	D	1	1	D
464	SP1	201516	2015-10-24	Malaga	La Coruna	2	0	H	0	0	D
465	SP1	201516	2015-10-24	Sevilla	Getafe	5	0	H	2	0	H
466	SP1	201516	2015-10-25	Ath Madrid	Valencia	2	1	H	2	0	H
467	SP1	201516	2015-10-25	Barcelona	Eibar	3	1	H	1	1	D
468	SP1	201516	2015-10-25	Las Palmas	Villarreal	0	0	D	0	0	D
469	SP1	201516	2015-10-25	Levante	Sociedad	0	4	A	0	2	A
470	SP1	201516	2015-10-26	Ath Bilbao	Sp Gijon	3	0	H	2	0	H
471	SP1	201516	2015-10-30	La Coruna	Ath Madrid	1	1	D	0	1	A
472	SP1	201516	2015-10-31	Getafe	Barcelona	0	2	A	0	1	A
473	SP1	201516	2015-10-31	Real Madrid	Las Palmas	3	1	H	3	1	H
474	SP1	201516	2015-10-31	Sociedad	Celta	2	3	A	2	1	H
475	SP1	201516	2015-10-31	Valencia	Levante	3	0	H	0	0	D
476	SP1	201516	2015-10-31	Villarreal	Sevilla	2	1	H	1	0	H
477	SP1	201516	2015-11-01	Betis	Ath Bilbao	1	3	A	0	2	A
479	SP1	201516	2015-11-01	Espanol	Granada	1	1	D	0	0	D
480	SP1	201516	2015-11-01	Sp Gijon	Malaga	1	0	H	1	0	H
481	SP1	201516	2015-11-06	Las Palmas	Sociedad	2	0	H	1	0	H
482	SP1	201516	2015-11-07	Celta	Valencia	1	5	A	1	2	A
484	SP1	201516	2015-11-07	Levante	La Coruna	1	1	D	0	1	A
485	SP1	201516	2015-11-07	Malaga	Betis	0	1	A	0	0	D
486	SP1	201516	2015-11-07	Vallecano	Granada	2	1	H	2	0	H
487	SP1	201516	2015-11-08	Ath Bilbao	Espanol	2	1	H	1	0	H
488	SP1	201516	2015-11-08	Ath Madrid	Sp Gijon	1	0	H	0	0	D
489	SP1	201516	2015-11-08	Barcelona	Villarreal	3	0	H	0	0	D
490	SP1	201516	2015-11-08	Sevilla	Real Madrid	3	2	H	1	1	D
491	SP1	201516	2015-11-21	Espanol	Malaga	2	0	H	2	0	H
492	SP1	201516	2015-11-21	La Coruna	Celta	2	0	H	1	0	H
493	SP1	201516	2015-11-21	Real Madrid	Barcelona	0	4	A	0	2	A
494	SP1	201516	2015-11-21	Sociedad	Sevilla	2	0	H	0	0	D
495	SP1	201516	2015-11-21	Valencia	Las Palmas	1	1	D	1	0	H
496	SP1	201516	2015-11-22	Betis	Ath Madrid	0	1	A	0	1	A
497	SP1	201516	2015-11-22	Granada	Ath Bilbao	2	0	H	1	0	H
498	SP1	201516	2015-11-22	Sp Gijon	Levante	0	3	A	0	3	A
499	SP1	201516	2015-11-22	Villarreal	Eibar	1	1	D	0	1	A
500	SP1	201516	2015-11-23	Getafe	Vallecano	1	1	D	0	0	D
501	SP1	201516	2015-11-27	Levante	Betis	0	1	A	0	1	A
502	SP1	201516	2015-11-28	Ath Madrid	Espanol	1	0	H	1	0	H
503	SP1	201516	2015-11-28	Barcelona	Sociedad	4	0	H	2	0	H
504	SP1	201516	2015-11-28	Celta	Sp Gijon	2	1	H	1	0	H
505	SP1	201516	2015-11-28	Las Palmas	La Coruna	0	2	A	0	1	A
506	SP1	201516	2015-11-28	Malaga	Granada	2	2	D	1	0	H
508	SP1	201516	2015-11-29	Getafe	Villarreal	2	0	H	1	0	H
509	SP1	201516	2015-11-29	Sevilla	Valencia	1	0	H	0	0	D
510	SP1	201516	2015-11-29	Vallecano	Ath Bilbao	0	3	A	0	2	A
511	SP1	201516	2015-12-05	Betis	Celta	1	1	D	0	1	A
512	SP1	201516	2015-12-05	Granada	Ath Madrid	0	2	A	0	1	A
513	SP1	201516	2015-12-05	La Coruna	Sevilla	1	1	D	1	0	H
514	SP1	201516	2015-12-05	Real Madrid	Getafe	4	1	H	4	0	H
515	SP1	201516	2015-12-05	Valencia	Barcelona	1	1	D	0	0	D
516	SP1	201516	2015-12-06	Ath Bilbao	Malaga	0	0	D	0	0	D
517	SP1	201516	2015-12-06	Sociedad	Eibar	2	1	H	1	1	D
518	SP1	201516	2015-12-06	Sp Gijon	Las Palmas	3	1	H	1	1	D
519	SP1	201516	2015-12-06	Villarreal	Vallecano	2	1	H	0	1	A
520	SP1	201516	2015-12-07	Espanol	Levante	1	1	D	0	1	A
521	SP1	201516	2015-12-11	Getafe	Sociedad	1	1	D	0	0	D
522	SP1	201516	2015-12-12	Barcelona	La Coruna	2	2	D	1	0	H
523	SP1	201516	2015-12-12	Celta	Espanol	1	0	H	1	0	H
524	SP1	201516	2015-12-12	Las Palmas	Betis	1	0	H	0	0	D
525	SP1	201516	2015-12-12	Levante	Granada	1	2	A	0	0	D
526	SP1	201516	2015-12-12	Sevilla	Sp Gijon	2	0	H	0	0	D
527	SP1	201516	2015-12-13	Ath Madrid	Ath Bilbao	2	1	H	1	1	D
529	SP1	201516	2015-12-13	Vallecano	Malaga	1	2	A	1	0	H
530	SP1	201516	2015-12-13	Villarreal	Real Madrid	1	0	H	1	0	H
531	SP1	201516	2015-12-19	Betis	Sevilla	0	0	D	0	0	D
532	SP1	201516	2015-12-19	Espanol	Las Palmas	1	0	H	0	0	D
533	SP1	201516	2015-12-19	La Coruna	Eibar	2	0	H	1	0	H
534	SP1	201516	2015-12-19	Valencia	Getafe	2	2	D	2	2	D
535	SP1	201516	2015-12-20	Ath Bilbao	Levante	2	0	H	0	0	D
536	SP1	201516	2015-12-20	Granada	Celta	0	2	A	0	2	A
537	SP1	201516	2015-12-20	Malaga	Ath Madrid	1	0	H	0	0	D
538	SP1	201516	2015-12-20	Real Madrid	Vallecano	10	2	H	4	2	H
539	SP1	201516	2015-12-20	Sociedad	Villarreal	0	2	A	0	1	A
540	SP1	201516	2015-12-30	Barcelona	Betis	4	0	H	2	0	H
541	SP1	201516	2015-12-30	Celta	Ath Bilbao	0	1	A	0	0	D
543	SP1	201516	2015-12-30	Getafe	La Coruna	0	0	D	0	0	D
544	SP1	201516	2015-12-30	Las Palmas	Granada	4	1	H	1	0	H
545	SP1	201516	2015-12-30	Levante	Malaga	0	1	A	0	0	D
546	SP1	201516	2015-12-30	Real Madrid	Sociedad	3	1	H	1	0	H
547	SP1	201516	2015-12-30	Sevilla	Espanol	2	0	H	2	0	H
548	SP1	201516	2015-12-30	Vallecano	Ath Madrid	0	2	A	0	0	D
549	SP1	201516	2015-12-31	Villarreal	Valencia	1	0	H	0	0	D
550	SP1	201516	2016-01-02	Ath Madrid	Levante	1	0	H	0	0	D
551	SP1	201516	2016-01-02	Espanol	Barcelona	0	0	D	0	0	D
552	SP1	201516	2016-01-02	Malaga	Celta	2	0	H	2	0	H
553	SP1	201516	2016-01-03	Ath Bilbao	Las Palmas	2	2	D	1	0	H
554	SP1	201516	2016-01-03	Betis	Eibar	0	4	A	0	2	A
555	SP1	201516	2016-01-03	Granada	Sevilla	2	1	H	2	1	H
556	SP1	201516	2016-01-03	La Coruna	Villarreal	1	2	A	0	1	A
557	SP1	201516	2016-01-03	Valencia	Real Madrid	2	2	D	1	1	D
558	SP1	201516	2016-01-03	Vallecano	Sociedad	2	2	D	1	1	D
559	SP1	201516	2016-01-04	Sp Gijon	Getafe	1	2	A	1	0	H
560	SP1	201516	2016-01-09	Barcelona	Granada	4	0	H	2	0	H
561	SP1	201516	2016-01-09	Getafe	Betis	1	0	H	0	0	D
562	SP1	201516	2016-01-09	Levante	Vallecano	2	1	H	0	0	D
563	SP1	201516	2016-01-09	Real Madrid	La Coruna	5	0	H	2	0	H
564	SP1	201516	2016-01-09	Sevilla	Ath Bilbao	2	0	H	1	0	H
565	SP1	201516	2016-01-10	Celta	Ath Madrid	0	2	A	0	0	D
567	SP1	201516	2016-01-10	Las Palmas	Malaga	1	1	D	0	0	D
568	SP1	201516	2016-01-10	Sociedad	Valencia	2	0	H	0	0	D
569	SP1	201516	2016-01-10	Villarreal	Sp Gijon	2	0	H	1	0	H
570	SP1	201516	2016-01-16	Celta	Levante	4	3	H	2	0	H
571	SP1	201516	2016-01-16	Sevilla	Malaga	2	1	H	2	0	H
572	SP1	201516	2016-01-16	Sociedad	La Coruna	1	1	D	0	1	A
573	SP1	201516	2016-01-16	Villarreal	Betis	0	0	D	0	0	D
574	SP1	201516	2016-01-17	Barcelona	Ath Bilbao	6	0	H	2	0	H
575	SP1	201516	2016-01-17	Getafe	Espanol	3	1	H	2	1	H
576	SP1	201516	2016-01-17	Las Palmas	Ath Madrid	0	3	A	0	1	A
577	SP1	201516	2016-01-17	Real Madrid	Sp Gijon	5	1	H	5	0	H
578	SP1	201516	2016-01-17	Valencia	Vallecano	2	2	D	0	1	A
580	SP1	201516	2016-01-22	Sp Gijon	Sociedad	5	1	H	3	1	H
581	SP1	201516	2016-01-23	Espanol	Villarreal	2	2	D	2	1	H
582	SP1	201516	2016-01-23	Granada	Getafe	3	2	H	2	0	H
583	SP1	201516	2016-01-23	Malaga	Barcelona	1	2	A	1	1	D
584	SP1	201516	2016-01-23	Vallecano	Celta	3	0	H	3	0	H
585	SP1	201516	2016-01-24	Ath Bilbao	Eibar	5	2	H	3	1	H
586	SP1	201516	2016-01-24	Ath Madrid	Sevilla	0	0	D	0	0	D
587	SP1	201516	2016-01-24	Betis	Real Madrid	1	1	D	1	0	H
588	SP1	201516	2016-01-24	La Coruna	Valencia	1	1	D	1	0	H
589	SP1	201516	2016-01-25	Levante	Las Palmas	3	2	H	1	0	H
590	SP1	201516	2016-01-30	Barcelona	Ath Madrid	2	1	H	2	1	H
592	SP1	201516	2016-01-30	Getafe	Ath Bilbao	0	1	A	0	1	A
593	SP1	201516	2016-01-30	Sociedad	Betis	2	1	H	2	0	H
594	SP1	201516	2016-01-30	Villarreal	Granada	1	0	H	0	0	D
595	SP1	201516	2016-01-31	Las Palmas	Celta	2	1	H	1	1	D
596	SP1	201516	2016-01-31	Real Madrid	Espanol	6	0	H	4	0	H
597	SP1	201516	2016-01-31	Sevilla	Levante	3	1	H	1	0	H
598	SP1	201516	2016-01-31	Valencia	Sp Gijon	0	1	A	0	0	D
599	SP1	201516	2016-02-01	La Coruna	Vallecano	2	2	D	1	2	A
600	SP1	201516	2016-02-05	Malaga	Getafe	3	0	H	3	0	H
601	SP1	201516	2016-02-06	Ath Bilbao	Villarreal	0	0	D	0	0	D
602	SP1	201516	2016-02-06	Ath Madrid	Eibar	3	1	H	0	0	D
603	SP1	201516	2016-02-06	Sp Gijon	La Coruna	1	1	D	1	1	D
604	SP1	201516	2016-02-06	Vallecano	Las Palmas	2	0	H	1	0	H
605	SP1	201516	2016-02-07	Betis	Valencia	1	0	H	0	0	D
606	SP1	201516	2016-02-07	Celta	Sevilla	1	1	D	0	1	A
607	SP1	201516	2016-02-07	Granada	Real Madrid	1	2	A	0	1	A
608	SP1	201516	2016-02-07	Levante	Barcelona	0	2	A	0	1	A
609	SP1	201516	2016-02-08	Espanol	Sociedad	0	5	A	0	2	A
610	SP1	201516	2016-02-12	Sp Gijon	Vallecano	2	2	D	2	1	H
611	SP1	201516	2016-02-13	La Coruna	Betis	2	2	D	1	2	A
612	SP1	201516	2016-02-13	Real Madrid	Ath Bilbao	4	2	H	3	1	H
613	SP1	201516	2016-02-13	Valencia	Espanol	2	1	H	0	0	D
614	SP1	201516	2016-02-13	Villarreal	Malaga	1	0	H	1	0	H
615	SP1	201516	2016-02-14	Barcelona	Celta	6	1	H	1	1	D
617	SP1	201516	2016-02-14	Getafe	Ath Madrid	0	1	A	0	1	A
618	SP1	201516	2016-02-14	Sevilla	Las Palmas	2	0	H	0	0	D
619	SP1	201516	2016-02-14	Sociedad	Granada	3	0	H	2	0	H
620	SP1	201516	2016-02-17	Sp Gijon	Barcelona	1	3	A	1	2	A
621	SP1	201516	2016-02-19	Levante	Getafe	3	0	H	2	0	H
622	SP1	201516	2016-02-20	Betis	Sp Gijon	1	1	D	0	0	D
623	SP1	201516	2016-02-20	Celta	Eibar	3	2	H	2	0	H
624	SP1	201516	2016-02-20	Espanol	La Coruna	1	0	H	0	0	D
625	SP1	201516	2016-02-20	Las Palmas	Barcelona	1	2	A	1	2	A
626	SP1	201516	2016-02-21	Ath Bilbao	Sociedad	0	1	A	0	1	A
627	SP1	201516	2016-02-21	Ath Madrid	Villarreal	0	0	D	0	0	D
628	SP1	201516	2016-02-21	Granada	Valencia	1	2	A	0	0	D
629	SP1	201516	2016-02-21	Malaga	Real Madrid	1	1	D	0	1	A
630	SP1	201516	2016-02-21	Vallecano	Sevilla	2	2	D	1	2	A
632	SP1	201516	2016-02-27	Betis	Vallecano	2	2	D	2	0	H
633	SP1	201516	2016-02-27	Getafe	Celta	0	1	A	0	0	D
634	SP1	201516	2016-02-27	Real Madrid	Ath Madrid	0	1	A	0	0	D
635	SP1	201516	2016-02-27	Sociedad	Malaga	1	1	D	0	0	D
636	SP1	201516	2016-02-27	Sp Gijon	Espanol	2	4	A	1	1	D
637	SP1	201516	2016-02-28	Barcelona	Sevilla	2	1	H	1	1	D
638	SP1	201516	2016-02-28	La Coruna	Granada	0	1	A	0	1	A
639	SP1	201516	2016-02-28	Valencia	Ath Bilbao	0	3	A	0	0	D
640	SP1	201516	2016-02-28	Villarreal	Levante	3	0	H	2	0	H
641	SP1	201516	2016-03-01	Ath Madrid	Sociedad	3	0	H	1	0	H
642	SP1	201516	2016-03-01	Las Palmas	Getafe	4	0	H	2	0	H
643	SP1	201516	2016-03-02	Ath Bilbao	La Coruna	4	1	H	2	0	H
644	SP1	201516	2016-03-02	Celta	Villarreal	0	0	D	0	0	D
645	SP1	201516	2016-03-02	Levante	Real Madrid	1	3	A	1	2	A
646	SP1	201516	2016-03-02	Malaga	Valencia	1	2	A	1	1	D
647	SP1	201516	2016-03-02	Sevilla	Eibar	1	0	H	1	0	H
648	SP1	201516	2016-03-03	Espanol	Betis	0	3	A	0	2	A
649	SP1	201516	2016-03-03	Granada	Sp Gijon	2	0	H	0	0	D
650	SP1	201516	2016-03-03	Vallecano	Barcelona	1	5	A	0	2	A
651	SP1	201516	2016-03-05	Getafe	Sevilla	1	1	D	0	0	D
652	SP1	201516	2016-03-05	La Coruna	Malaga	3	3	D	1	1	D
653	SP1	201516	2016-03-05	Real Madrid	Celta	7	1	H	1	0	H
654	SP1	201516	2016-03-05	Villarreal	Las Palmas	0	1	A	0	1	A
655	SP1	201516	2016-03-06	Betis	Granada	2	0	H	0	0	D
657	SP1	201516	2016-03-06	Sociedad	Levante	1	1	D	1	1	D
658	SP1	201516	2016-03-06	Sp Gijon	Ath Bilbao	0	2	A	0	1	A
659	SP1	201516	2016-03-06	Valencia	Ath Madrid	1	3	A	1	1	D
660	SP1	201516	2016-03-07	Espanol	Vallecano	2	1	H	1	0	H
661	SP1	201516	2016-03-11	Malaga	Sp Gijon	1	0	H	1	0	H
662	SP1	201516	2016-03-12	Ath Madrid	La Coruna	3	0	H	1	0	H
663	SP1	201516	2016-03-12	Barcelona	Getafe	6	0	H	4	0	H
664	SP1	201516	2016-03-12	Celta	Sociedad	1	0	H	1	0	H
665	SP1	201516	2016-03-12	Vallecano	Eibar	1	1	D	1	1	D
666	SP1	201516	2016-03-13	Ath Bilbao	Betis	3	1	H	2	0	H
667	SP1	201516	2016-03-13	Las Palmas	Real Madrid	1	2	A	0	1	A
668	SP1	201516	2016-03-13	Levante	Valencia	1	0	H	0	0	D
669	SP1	201516	2016-03-13	Sevilla	Villarreal	4	2	H	1	2	A
670	SP1	201516	2016-03-14	Granada	Espanol	1	1	D	1	0	H
671	SP1	201516	2016-03-18	Getafe	Eibar	1	1	D	1	0	H
672	SP1	201516	2016-03-19	Betis	Malaga	0	1	A	0	0	D
673	SP1	201516	2016-03-19	Granada	Vallecano	2	2	D	1	1	D
674	SP1	201516	2016-03-19	La Coruna	Levante	2	1	H	1	0	H
675	SP1	201516	2016-03-19	Sociedad	Las Palmas	0	1	A	0	1	A
676	SP1	201516	2016-03-19	Sp Gijon	Ath Madrid	2	1	H	0	1	A
677	SP1	201516	2016-03-20	Espanol	Ath Bilbao	2	1	H	0	1	A
678	SP1	201516	2016-03-20	Real Madrid	Sevilla	4	0	H	1	0	H
679	SP1	201516	2016-03-20	Valencia	Celta	0	2	A	0	0	D
680	SP1	201516	2016-03-20	Villarreal	Barcelona	2	2	D	0	2	A
681	SP1	201516	2016-04-01	Vallecano	Getafe	2	0	H	1	0	H
682	SP1	201516	2016-04-02	Ath Madrid	Betis	5	1	H	2	0	H
683	SP1	201516	2016-04-02	Barcelona	Real Madrid	1	2	A	0	0	D
684	SP1	201516	2016-04-02	Celta	La Coruna	1	1	D	1	1	D
685	SP1	201516	2016-04-02	Las Palmas	Valencia	2	1	H	0	1	A
686	SP1	201516	2016-04-03	Ath Bilbao	Granada	1	1	D	1	0	H
688	SP1	201516	2016-04-03	Malaga	Espanol	1	1	D	1	1	D
689	SP1	201516	2016-04-03	Sevilla	Sociedad	1	2	A	0	2	A
690	SP1	201516	2016-04-04	Levante	Sp Gijon	0	0	D	0	0	D
691	SP1	201516	2016-04-08	Granada	Malaga	0	0	D	0	0	D
692	SP1	201516	2016-04-09	Betis	Levante	1	0	H	0	0	D
693	SP1	201516	2016-04-09	Espanol	Ath Madrid	1	3	A	1	1	D
694	SP1	201516	2016-04-09	Real Madrid	Eibar	4	0	H	4	0	H
695	SP1	201516	2016-04-09	Sociedad	Barcelona	1	0	H	1	0	H
696	SP1	201516	2016-04-10	Ath Bilbao	Vallecano	1	0	H	0	0	D
697	SP1	201516	2016-04-10	Sp Gijon	Celta	0	1	A	0	0	D
698	SP1	201516	2016-04-10	Valencia	Sevilla	2	1	H	1	0	H
699	SP1	201516	2016-04-10	Villarreal	Getafe	2	0	H	1	0	H
700	SP1	201516	2016-04-11	La Coruna	Las Palmas	1	3	A	0	0	D
701	SP1	201516	2016-04-15	Levante	Espanol	2	1	H	1	1	D
702	SP1	201516	2016-04-16	Celta	Betis	1	1	D	0	1	A
704	SP1	201516	2016-04-16	Getafe	Real Madrid	1	5	A	0	2	A
705	SP1	201516	2016-04-16	Las Palmas	Sp Gijon	1	1	D	1	0	H
706	SP1	201516	2016-04-17	Ath Madrid	Granada	3	0	H	1	0	H
707	SP1	201516	2016-04-17	Barcelona	Valencia	1	2	A	0	2	A
708	SP1	201516	2016-04-17	Malaga	Ath Bilbao	0	1	A	0	0	D
709	SP1	201516	2016-04-17	Sevilla	La Coruna	1	1	D	1	0	H
710	SP1	201516	2016-04-17	Vallecano	Villarreal	2	1	H	1	1	D
711	SP1	201516	2016-04-19	Betis	Las Palmas	1	0	H	0	0	D
712	SP1	201516	2016-04-19	Espanol	Celta	1	1	D	1	1	D
713	SP1	201516	2016-04-20	Ath Bilbao	Ath Madrid	0	1	A	0	1	A
714	SP1	201516	2016-04-20	La Coruna	Barcelona	0	8	A	0	2	A
715	SP1	201516	2016-04-20	Malaga	Vallecano	1	1	D	0	0	D
716	SP1	201516	2016-04-20	Real Madrid	Villarreal	3	0	H	1	0	H
717	SP1	201516	2016-04-20	Sp Gijon	Sevilla	2	1	H	1	1	D
718	SP1	201516	2016-04-20	Valencia	Eibar	4	0	H	3	0	H
719	SP1	201516	2016-04-21	Granada	Levante	5	1	H	3	0	H
720	SP1	201516	2016-04-21	Sociedad	Getafe	1	2	A	1	1	D
721	SP1	201516	2016-04-22	Las Palmas	Espanol	4	0	H	1	0	H
722	SP1	201516	2016-04-23	Ath Madrid	Malaga	1	0	H	0	0	D
723	SP1	201516	2016-04-23	Barcelona	Sp Gijon	6	0	H	1	0	H
725	SP1	201516	2016-04-23	Vallecano	Real Madrid	2	3	A	2	1	H
726	SP1	201516	2016-04-24	Getafe	Valencia	2	2	D	0	0	D
727	SP1	201516	2016-04-24	Levante	Ath Bilbao	2	2	D	1	0	H
728	SP1	201516	2016-04-24	Sevilla	Betis	2	0	H	0	0	D
729	SP1	201516	2016-04-24	Villarreal	Sociedad	0	0	D	0	0	D
730	SP1	201516	2016-04-25	Celta	Granada	2	1	H	1	0	H
731	SP1	201516	2016-04-29	Sp Gijon	Eibar	2	0	H	1	0	H
732	SP1	201516	2016-04-30	Ath Madrid	Vallecano	1	0	H	0	0	D
733	SP1	201516	2016-04-30	Betis	Barcelona	0	2	A	0	0	D
734	SP1	201516	2016-04-30	Granada	Las Palmas	3	2	H	2	2	D
735	SP1	201516	2016-04-30	Sociedad	Real Madrid	0	1	A	0	0	D
736	SP1	201516	2016-05-01	Ath Bilbao	Celta	2	1	H	1	1	D
737	SP1	201516	2016-05-01	Espanol	Sevilla	1	0	H	0	0	D
738	SP1	201516	2016-05-01	La Coruna	Getafe	0	2	A	0	1	A
739	SP1	201516	2016-05-01	Valencia	Villarreal	0	2	A	0	2	A
740	SP1	201516	2016-05-02	Malaga	Levante	3	1	H	1	1	D
741	SP1	201516	2016-05-08	Barcelona	Espanol	5	0	H	1	0	H
742	SP1	201516	2016-05-08	Celta	Malaga	1	0	H	1	0	H
744	SP1	201516	2016-05-08	Getafe	Sp Gijon	1	1	D	0	0	D
745	SP1	201516	2016-05-08	Las Palmas	Ath Bilbao	0	0	D	0	0	D
746	SP1	201516	2016-05-08	Levante	Ath Madrid	2	1	H	1	1	D
747	SP1	201516	2016-05-08	Real Madrid	Valencia	3	2	H	2	0	H
748	SP1	201516	2016-05-08	Sevilla	Granada	1	4	A	0	1	A
749	SP1	201516	2016-05-08	Sociedad	Vallecano	2	1	H	1	0	H
750	SP1	201516	2016-05-08	Villarreal	La Coruna	0	2	A	0	1	A
703	SP1	201516	2016-04-16	Eibar	Sociedad	2	1	H	1	1	D
751	SP1	201516	2016-05-13	Valencia	Sociedad	0	1	A	0	0	D
752	SP1	201516	2016-05-14	Ath Bilbao	Sevilla	3	1	H	2	0	H
753	SP1	201516	2016-05-14	Ath Madrid	Celta	2	0	H	0	0	D
754	SP1	201516	2016-05-14	Granada	Barcelona	0	3	A	0	2	A
755	SP1	201516	2016-05-14	La Coruna	Real Madrid	0	2	A	0	2	A
756	SP1	201516	2016-05-15	Betis	Getafe	2	1	H	0	0	D
757	SP1	201516	2016-05-15	Espanol	Eibar	4	2	H	2	0	H
758	SP1	201516	2016-05-15	Malaga	Las Palmas	4	1	H	2	1	H
759	SP1	201516	2016-05-15	Sp Gijon	Villarreal	2	0	H	1	0	H
760	SP1	201516	2016-05-15	Vallecano	Levante	3	1	H	2	0	H
761	SP2	201617	2016-08-19	Almeria	Cadiz	1	1	D	0	0	D
762	SP2	201617	2016-08-19	Mirandes	Getafe	1	1	D	0	0	D
763	SP2	201617	2016-08-20	Alcorcon	Huesca	0	0	D	0	0	D
764	SP2	201617	2016-08-20	Cordoba	Tenerife	1	0	H	1	0	H
765	SP2	201617	2016-08-20	Elche	Vallecano	2	1	H	2	1	H
766	SP2	201617	2016-08-20	Mallorca	Reus Deportiu	0	1	A	0	0	D
767	SP2	201617	2016-08-21	Gimnastic	Lugo	2	2	D	0	2	A
768	SP2	201617	2016-08-21	Numancia	Levante	0	1	A	0	0	D
769	SP2	201617	2016-08-21	Sevilla B	Girona	3	3	D	1	0	H
770	SP2	201617	2016-08-21	Valladolid	Oviedo	1	0	H	1	0	H
771	SP2	201617	2016-08-22	Zaragoza	UCAM Murcia	3	1	H	3	0	H
772	SP2	201617	2016-08-26	Getafe	Numancia	0	0	D	0	0	D
773	SP2	201617	2016-08-26	Tenerife	Sevilla B	1	1	D	0	1	A
774	SP2	201617	2016-08-27	Girona	Elche	3	1	H	2	0	H
775	SP2	201617	2016-08-27	Lugo	Zaragoza	3	3	D	1	1	D
776	SP2	201617	2016-08-27	Oviedo	Almeria	2	0	H	0	0	D
777	SP2	201617	2016-08-27	Reus Deportiu	Mirandes	1	1	D	1	1	D
778	SP2	201617	2016-08-28	Cadiz	Mallorca	1	1	D	1	0	H
779	SP2	201617	2016-08-28	Huesca	Gimnastic	1	1	D	0	0	D
780	SP2	201617	2016-08-28	Levante	Alcorcon	2	0	H	2	0	H
781	SP2	201617	2016-08-28	UCAM Murcia	Cordoba	1	1	D	0	0	D
782	SP2	201617	2016-08-28	Vallecano	Valladolid	0	0	D	0	0	D
783	SP2	201617	2016-09-02	Cordoba	Lugo	3	3	D	1	1	D
784	SP2	201617	2016-09-02	Sevilla B	UCAM Murcia	1	1	D	0	0	D
785	SP2	201617	2016-09-03	Almeria	Vallecano	3	0	H	2	0	H
786	SP2	201617	2016-09-03	Elche	Tenerife	3	1	H	1	0	H
787	SP2	201617	2016-09-03	Getafe	Reus Deportiu	1	1	D	0	0	D
788	SP2	201617	2016-09-03	Mirandes	Cadiz	3	2	H	0	2	A
789	SP2	201617	2016-09-03	Valladolid	Girona	2	1	H	2	0	H
790	SP2	201617	2016-09-04	Gimnastic	Levante	1	1	D	0	0	D
791	SP2	201617	2016-09-04	Mallorca	Oviedo	0	0	D	0	0	D
792	SP2	201617	2016-09-04	Numancia	Alcorcon	1	1	D	1	1	D
793	SP2	201617	2016-09-04	Zaragoza	Huesca	1	0	H	0	0	D
794	SP2	201617	2016-09-10	Levante	Zaragoza	4	2	H	3	1	H
795	SP2	201617	2016-09-10	Lugo	Sevilla B	1	0	H	0	0	D
796	SP2	201617	2016-09-10	Reus Deportiu	Numancia	1	1	D	0	0	D
797	SP2	201617	2016-09-10	Tenerife	Valladolid	1	0	H	1	0	H
798	SP2	201617	2016-09-11	Alcorcon	Gimnastic	1	0	H	0	0	D
799	SP2	201617	2016-09-11	Cadiz	Getafe	3	0	H	1	0	H
800	SP2	201617	2016-09-11	Girona	Almeria	3	3	D	2	1	H
801	SP2	201617	2016-09-11	Huesca	Cordoba	3	0	H	2	0	H
802	SP2	201617	2016-09-11	Oviedo	Mirandes	0	0	D	0	0	D
803	SP2	201617	2016-09-11	UCAM Murcia	Elche	1	1	D	0	1	A
804	SP2	201617	2016-09-11	Vallecano	Mallorca	1	0	H	0	0	D
805	SP2	201617	2016-09-17	Cordoba	Levante	1	0	H	1	0	H
806	SP2	201617	2016-09-17	Elche	Lugo	0	3	A	0	2	A
807	SP2	201617	2016-09-17	Numancia	Gimnastic	1	0	H	1	0	H
808	SP2	201617	2016-09-17	Reus Deportiu	Cadiz	1	0	H	0	0	D
809	SP2	201617	2016-09-17	Valladolid	UCAM Murcia	0	1	A	0	0	D
810	SP2	201617	2016-09-17	Zaragoza	Alcorcon	2	0	H	1	0	H
811	SP2	201617	2016-09-18	Almeria	Tenerife	0	1	A	0	0	D
812	SP2	201617	2016-09-18	Getafe	Oviedo	2	1	H	0	1	A
813	SP2	201617	2016-09-18	Mallorca	Girona	1	0	H	1	0	H
814	SP2	201617	2016-09-18	Mirandes	Vallecano	2	1	H	1	1	D
815	SP2	201617	2016-09-18	Sevilla B	Huesca	2	0	H	0	0	D
816	SP2	201617	2016-09-20	Alcorcon	Cordoba	0	1	A	0	0	D
817	SP2	201617	2016-09-20	Cadiz	Numancia	1	0	H	0	0	D
818	SP2	201617	2016-09-20	Gimnastic	Zaragoza	0	0	D	0	0	D
819	SP2	201617	2016-09-20	Lugo	Valladolid	1	0	H	1	0	H
820	SP2	201617	2016-09-21	Huesca	Elche	0	3	A	0	0	D
821	SP2	201617	2016-09-21	Levante	Sevilla B	1	0	H	0	0	D
822	SP2	201617	2016-09-21	UCAM Murcia	Almeria	4	0	H	1	0	H
823	SP2	201617	2016-09-22	Girona	Mirandes	1	1	D	0	0	D
824	SP2	201617	2016-09-22	Oviedo	Reus Deportiu	0	1	A	0	0	D
825	SP2	201617	2016-09-22	Tenerife	Mallorca	0	0	D	0	0	D
826	SP2	201617	2016-09-22	Vallecano	Getafe	2	0	H	1	0	H
827	SP2	201617	2016-09-24	Almeria	Lugo	0	0	D	0	0	D
828	SP2	201617	2016-09-24	Cordoba	Gimnastic	2	0	H	1	0	H
829	SP2	201617	2016-09-24	Elche	Levante	0	1	A	0	0	D
830	SP2	201617	2016-09-24	Sevilla B	Alcorcon	1	1	D	1	0	H
831	SP2	201617	2016-09-24	Valladolid	Huesca	1	2	A	0	0	D
832	SP2	201617	2016-09-25	Cadiz	Oviedo	0	2	A	0	2	A
833	SP2	201617	2016-09-25	Getafe	Girona	0	2	A	0	1	A
834	SP2	201617	2016-09-25	Mallorca	UCAM Murcia	0	0	D	0	0	D
835	SP2	201617	2016-09-25	Mirandes	Tenerife	3	2	H	2	0	H
836	SP2	201617	2016-09-25	Numancia	Zaragoza	2	1	H	1	1	D
837	SP2	201617	2016-09-25	Reus Deportiu	Vallecano	1	1	D	1	0	H
838	SP2	201617	2016-10-01	Alcorcon	Elche	1	0	H	0	0	D
839	SP2	201617	2016-10-01	Gimnastic	Sevilla B	1	1	D	1	1	D
840	SP2	201617	2016-10-01	Huesca	Almeria	2	0	H	1	0	H
841	SP2	201617	2016-10-01	Lugo	Mallorca	3	1	H	2	1	H
842	SP2	201617	2016-10-01	Zaragoza	Cordoba	1	1	D	1	1	D
843	SP2	201617	2016-10-02	Girona	Reus Deportiu	1	0	H	0	0	D
844	SP2	201617	2016-10-02	Levante	Valladolid	3	2	H	1	1	D
845	SP2	201617	2016-10-02	Oviedo	Numancia	2	2	D	1	1	D
846	SP2	201617	2016-10-02	Tenerife	Getafe	0	0	D	0	0	D
847	SP2	201617	2016-10-02	UCAM Murcia	Mirandes	2	2	D	1	2	A
848	SP2	201617	2016-10-02	Vallecano	Cadiz	3	0	H	1	0	H
849	SP2	201617	2016-10-08	Elche	Gimnastic	4	4	D	2	1	H
850	SP2	201617	2016-10-08	Getafe	UCAM Murcia	2	0	H	0	0	D
851	SP2	201617	2016-10-08	Numancia	Cordoba	1	1	D	1	0	H
852	SP2	201617	2016-10-08	Reus Deportiu	Tenerife	0	0	D	0	0	D
853	SP2	201617	2016-10-08	Sevilla B	Zaragoza	2	1	H	0	0	D
854	SP2	201617	2016-10-08	Valladolid	Alcorcon	2	0	H	2	0	H
855	SP2	201617	2016-10-09	Almeria	Levante	2	2	D	1	0	H
856	SP2	201617	2016-10-09	Cadiz	Girona	0	0	D	0	0	D
857	SP2	201617	2016-10-09	Mallorca	Huesca	3	0	H	2	0	H
858	SP2	201617	2016-10-09	Mirandes	Lugo	2	2	D	0	2	A
859	SP2	201617	2016-10-09	Oviedo	Vallecano	2	0	H	1	0	H
860	SP2	201617	2016-10-15	Alcorcon	Almeria	0	0	D	0	0	D
861	SP2	201617	2016-10-15	Girona	Oviedo	0	0	D	0	0	D
862	SP2	201617	2016-10-15	Huesca	Mirandes	3	0	H	1	0	H
863	SP2	201617	2016-10-15	Levante	Mallorca	2	1	H	1	1	D
864	SP2	201617	2016-10-15	Lugo	Getafe	0	1	A	0	0	D
865	SP2	201617	2016-10-16	Cordoba	Sevilla B	0	1	A	0	0	D
866	SP2	201617	2016-10-16	Gimnastic	Valladolid	1	2	A	1	1	D
867	SP2	201617	2016-10-16	Tenerife	Cadiz	1	1	D	0	0	D
868	SP2	201617	2016-10-16	UCAM Murcia	Reus Deportiu	0	2	A	0	2	A
869	SP2	201617	2016-10-16	Vallecano	Numancia	3	3	D	1	1	D
870	SP2	201617	2016-10-16	Zaragoza	Elche	1	3	A	0	3	A
871	SP2	201617	2016-10-22	Elche	Cordoba	1	1	D	1	0	H
872	SP2	201617	2016-10-22	Getafe	Huesca	1	1	D	0	0	D
873	SP2	201617	2016-10-22	Numancia	Sevilla B	1	2	A	1	1	D
874	SP2	201617	2016-10-22	Reus Deportiu	Lugo	2	1	H	2	0	H
875	SP2	201617	2016-10-22	Vallecano	Girona	1	0	H	0	0	D
876	SP2	201617	2016-10-23	Almeria	Gimnastic	3	0	H	1	0	H
877	SP2	201617	2016-10-23	Cadiz	UCAM Murcia	2	2	D	2	0	H
878	SP2	201617	2016-10-23	Mallorca	Alcorcon	1	0	H	0	0	D
879	SP2	201617	2016-10-23	Mirandes	Levante	0	3	A	0	1	A
880	SP2	201617	2016-10-23	Oviedo	Tenerife	2	0	H	1	0	H
881	SP2	201617	2016-10-23	Valladolid	Zaragoza	0	0	D	0	0	D
882	SP2	201617	2016-10-29	Cordoba	Valladolid	1	1	D	1	1	D
883	SP2	201617	2016-10-29	Huesca	Reus Deportiu	2	1	H	0	1	A
884	SP2	201617	2016-10-29	Tenerife	Vallecano	3	2	H	2	1	H
885	SP2	201617	2016-10-29	Zaragoza	Almeria	2	1	H	1	0	H
886	SP2	201617	2016-10-30	Alcorcon	Mirandes	1	0	H	0	0	D
887	SP2	201617	2016-10-30	Gimnastic	Mallorca	2	2	D	1	0	H
888	SP2	201617	2016-10-30	Girona	Numancia	3	0	H	3	0	H
889	SP2	201617	2016-10-30	Levante	Getafe	1	1	D	1	1	D
890	SP2	201617	2016-10-30	Lugo	Cadiz	0	1	A	0	0	D
891	SP2	201617	2016-10-30	Sevilla B	Elche	2	0	H	0	0	D
892	SP2	201617	2016-10-30	UCAM Murcia	Oviedo	0	1	A	0	1	A
893	SP2	201617	2016-11-05	Cadiz	Huesca	1	0	H	0	0	D
894	SP2	201617	2016-11-05	Girona	Tenerife	1	1	D	1	1	D
895	SP2	201617	2016-11-05	Mallorca	Zaragoza	2	2	D	0	1	A
896	SP2	201617	2016-11-05	Valladolid	Sevilla B	2	0	H	0	0	D
897	SP2	201617	2016-11-05	Vallecano	UCAM Murcia	0	1	A	0	0	D
898	SP2	201617	2016-11-06	Almeria	Cordoba	3	1	H	3	1	H
899	SP2	201617	2016-11-06	Getafe	Alcorcon	1	0	H	0	0	D
900	SP2	201617	2016-11-06	Mirandes	Gimnastic	0	1	A	0	0	D
901	SP2	201617	2016-11-06	Numancia	Elche	2	2	D	2	0	H
902	SP2	201617	2016-11-06	Oviedo	Lugo	1	1	D	0	1	A
903	SP2	201617	2016-11-06	Reus Deportiu	Levante	0	1	A	0	0	D
904	SP2	201617	2016-11-11	Cordoba	Mallorca	0	2	A	0	0	D
905	SP2	201617	2016-11-12	Alcorcon	Reus Deportiu	1	0	H	0	0	D
906	SP2	201617	2016-11-12	Elche	Valladolid	2	0	H	1	0	H
907	SP2	201617	2016-11-12	Gimnastic	Getafe	1	0	H	1	0	H
908	SP2	201617	2016-11-12	Huesca	Oviedo	4	0	H	3	0	H
909	SP2	201617	2016-11-12	Levante	Cadiz	0	0	D	0	0	D
910	SP2	201617	2016-11-12	Tenerife	Numancia	1	1	D	1	0	H
911	SP2	201617	2016-11-13	Lugo	Vallecano	1	0	H	1	0	H
912	SP2	201617	2016-11-13	Sevilla B	Almeria	1	0	H	1	0	H
913	SP2	201617	2016-11-13	UCAM Murcia	Girona	0	1	A	0	0	D
914	SP2	201617	2016-11-13	Zaragoza	Mirandes	2	0	H	2	0	H
915	SP2	201617	2016-11-18	Almeria	Elche	2	1	H	1	1	D
916	SP2	201617	2016-11-19	Girona	Lugo	3	1	H	2	1	H
917	SP2	201617	2016-11-19	Mallorca	Sevilla B	2	2	D	0	2	A
918	SP2	201617	2016-11-19	Numancia	Valladolid	2	1	H	1	0	H
919	SP2	201617	2016-11-19	Oviedo	Levante	2	0	H	0	0	D
920	SP2	201617	2016-11-20	Cadiz	Alcorcon	4	1	H	0	1	A
921	SP2	201617	2016-11-20	Getafe	Zaragoza	1	0	H	0	0	D
922	SP2	201617	2016-11-20	Mirandes	Cordoba	1	1	D	1	0	H
923	SP2	201617	2016-11-20	Reus Deportiu	Gimnastic	1	0	H	0	0	D
924	SP2	201617	2016-11-20	Tenerife	UCAM Murcia	2	1	H	2	1	H
925	SP2	201617	2016-11-20	Vallecano	Huesca	2	2	D	1	1	D
926	SP2	201617	2016-11-25	Gimnastic	Cadiz	1	0	H	0	0	D
927	SP2	201617	2016-11-26	Alcorcon	Oviedo	5	1	H	2	0	H
928	SP2	201617	2016-11-26	Lugo	Tenerife	1	3	A	1	1	D
929	SP2	201617	2016-11-26	UCAM Murcia	Numancia	3	2	H	0	1	A
930	SP2	201617	2016-11-26	Valladolid	Almeria	0	0	D	0	0	D
931	SP2	201617	2016-11-26	Zaragoza	Reus Deportiu	2	2	D	1	0	H
932	SP2	201617	2016-11-27	Cordoba	Getafe	1	3	A	0	1	A
933	SP2	201617	2016-11-27	Elche	Mallorca	1	0	H	0	0	D
934	SP2	201617	2016-11-27	Huesca	Girona	1	2	A	1	2	A
935	SP2	201617	2016-11-27	Sevilla B	Mirandes	1	0	H	1	0	H
936	SP2	201617	2016-12-02	Getafe	Sevilla B	2	0	H	1	0	H
937	SP2	201617	2016-12-03	Cadiz	Zaragoza	3	0	H	1	0	H
938	SP2	201617	2016-12-03	Mirandes	Elche	1	0	H	1	0	H
939	SP2	201617	2016-12-03	Numancia	Almeria	1	0	H	1	0	H
940	SP2	201617	2016-12-03	UCAM Murcia	Lugo	1	2	A	1	1	D
941	SP2	201617	2016-12-04	Girona	Levante	2	1	H	1	0	H
942	SP2	201617	2016-12-04	Mallorca	Valladolid	0	3	A	0	0	D
943	SP2	201617	2016-12-04	Oviedo	Gimnastic	1	0	H	1	0	H
944	SP2	201617	2016-12-04	Reus Deportiu	Cordoba	1	2	A	0	1	A
945	SP2	201617	2016-12-04	Tenerife	Huesca	1	1	D	1	0	H
946	SP2	201617	2016-12-04	Vallecano	Alcorcon	2	0	H	0	0	D
947	SP2	201617	2016-12-09	Sevilla B	Reus Deportiu	0	1	A	0	0	D
948	SP2	201617	2016-12-10	Elche	Getafe	2	2	D	0	2	A
949	SP2	201617	2016-12-10	Gimnastic	Vallecano	0	1	A	0	0	D
950	SP2	201617	2016-12-10	Huesca	UCAM Murcia	5	2	H	2	1	H
951	SP2	201617	2016-12-10	Levante	Tenerife	1	0	H	0	0	D
952	SP2	201617	2016-12-11	Alcorcon	Girona	2	1	H	2	0	H
953	SP2	201617	2016-12-11	Almeria	Mallorca	2	1	H	1	0	H
954	SP2	201617	2016-12-11	Cordoba	Cadiz	1	3	A	0	0	D
955	SP2	201617	2016-12-11	Lugo	Numancia	3	1	H	1	1	D
956	SP2	201617	2016-12-11	Valladolid	Mirandes	5	0	H	2	0	H
957	SP2	201617	2016-12-11	Zaragoza	Oviedo	2	1	H	1	0	H
958	SP2	201617	2016-12-14	Levante	Vallecano	1	0	H	1	0	H
959	SP2	201617	2016-12-16	Reus Deportiu	Elche	0	1	A	0	0	D
960	SP2	201617	2016-12-17	Getafe	Valladolid	3	1	H	0	0	D
961	SP2	201617	2016-12-17	Girona	Gimnastic	4	2	H	1	2	A
962	SP2	201617	2016-12-17	Lugo	Huesca	1	1	D	0	1	A
963	SP2	201617	2016-12-17	Oviedo	Cordoba	1	2	A	0	1	A
964	SP2	201617	2016-12-17	Tenerife	Alcorcon	2	0	H	1	0	H
965	SP2	201617	2016-12-18	Cadiz	Sevilla B	4	1	H	1	0	H
966	SP2	201617	2016-12-18	Mirandes	Almeria	2	1	H	0	0	D
967	SP2	201617	2016-12-18	Numancia	Mallorca	3	1	H	2	1	H
968	SP2	201617	2016-12-18	Vallecano	Zaragoza	1	2	A	0	0	D
969	SP2	201617	2017-01-06	Almeria	Getafe	0	1	A	0	0	D
970	SP2	201617	2017-01-06	Mallorca	Mirandes	2	0	H	0	0	D
971	SP2	201617	2017-01-06	Numancia	Huesca	0	0	D	0	0	D
972	SP2	201617	2017-01-06	Valladolid	Reus Deportiu	1	0	H	0	0	D
973	SP2	201617	2017-01-07	Cordoba	Vallecano	0	0	D	0	0	D
974	SP2	201617	2017-01-07	Levante	Lugo	1	0	H	0	0	D
975	SP2	201617	2017-01-08	Alcorcon	UCAM Murcia	0	0	D	0	0	D
976	SP2	201617	2017-01-08	Elche	Cadiz	2	3	A	1	1	D
977	SP2	201617	2017-01-08	Gimnastic	Tenerife	1	1	D	0	1	A
978	SP2	201617	2017-01-08	Sevilla B	Oviedo	5	3	H	3	0	H
979	SP2	201617	2017-01-08	Zaragoza	Girona	0	2	A	0	0	D
980	SP2	201617	2017-01-11	UCAM Murcia	Levante	0	2	A	0	1	A
981	SP2	201617	2017-01-13	Cadiz	Valladolid	0	1	A	0	1	A
982	SP2	201617	2017-01-14	Mirandes	Numancia	0	3	A	0	1	A
983	SP2	201617	2017-01-14	Oviedo	Elche	2	1	H	0	0	D
984	SP2	201617	2017-01-14	Tenerife	Zaragoza	1	0	H	0	0	D
985	SP2	201617	2017-01-14	UCAM Murcia	Gimnastic	1	1	D	0	1	A
986	SP2	201617	2017-01-14	Vallecano	Sevilla B	1	1	D	0	1	A
987	SP2	201617	2017-01-15	Getafe	Mallorca	1	1	D	0	1	A
988	SP2	201617	2017-01-15	Girona	Cordoba	2	0	H	1	0	H
989	SP2	201617	2017-01-15	Huesca	Levante	0	2	A	0	1	A
990	SP2	201617	2017-01-15	Lugo	Alcorcon	1	0	H	0	0	D
991	SP2	201617	2017-01-15	Reus Deportiu	Almeria	1	0	H	1	0	H
992	SP2	201617	2017-01-21	Huesca	Alcorcon	0	1	A	0	0	D
993	SP2	201617	2017-01-21	Lugo	Gimnastic	2	3	A	1	0	H
994	SP2	201617	2017-01-21	Oviedo	Valladolid	1	0	H	1	0	H
995	SP2	201617	2017-01-21	Tenerife	Cordoba	2	0	H	0	0	D
996	SP2	201617	2017-01-21	UCAM Murcia	Zaragoza	1	0	H	1	0	H
997	SP2	201617	2017-01-21	Vallecano	Elche	1	1	D	0	1	A
998	SP2	201617	2017-01-22	Cadiz	Almeria	1	0	H	0	0	D
999	SP2	201617	2017-01-22	Getafe	Mirandes	1	1	D	1	0	H
1000	SP2	201617	2017-01-22	Girona	Sevilla B	2	0	H	0	0	D
1001	SP2	201617	2017-01-22	Levante	Numancia	1	0	H	1	0	H
1002	SP2	201617	2017-01-22	Reus Deportiu	Mallorca	1	1	D	0	1	A
1003	SP2	201617	2017-01-27	Elche	Girona	1	0	H	0	0	D
1004	SP2	201617	2017-01-28	Alcorcon	Levante	2	0	H	2	0	H
1005	SP2	201617	2017-01-28	Gimnastic	Huesca	0	0	D	0	0	D
1006	SP2	201617	2017-01-28	Mirandes	Reus Deportiu	1	1	D	1	0	H
1007	SP2	201617	2017-01-28	Sevilla B	Tenerife	0	0	D	0	0	D
1008	SP2	201617	2017-01-28	Valladolid	Vallecano	2	1	H	0	1	A
1009	SP2	201617	2017-01-29	Almeria	Oviedo	3	0	H	0	0	D
1010	SP2	201617	2017-01-29	Cordoba	UCAM Murcia	1	1	D	1	0	H
1011	SP2	201617	2017-01-29	Mallorca	Cadiz	0	0	D	0	0	D
1012	SP2	201617	2017-01-29	Numancia	Getafe	2	0	H	1	0	H
1013	SP2	201617	2017-01-29	Zaragoza	Lugo	1	1	D	0	0	D
1014	SP2	201617	2017-02-03	UCAM Murcia	Sevilla B	1	0	H	0	0	D
1015	SP2	201617	2017-02-04	Alcorcon	Numancia	2	3	A	1	1	D
1016	SP2	201617	2017-02-04	Cadiz	Mirandes	2	1	H	1	1	D
1017	SP2	201617	2017-02-04	Huesca	Zaragoza	2	3	A	0	0	D
1018	SP2	201617	2017-02-04	Lugo	Cordoba	1	0	H	1	0	H
1019	SP2	201617	2017-02-04	Tenerife	Elche	2	0	H	1	0	H
1020	SP2	201617	2017-02-05	Girona	Valladolid	2	1	H	1	0	H
1021	SP2	201617	2017-02-05	Levante	Gimnastic	2	1	H	0	0	D
1022	SP2	201617	2017-02-05	Oviedo	Mallorca	2	1	H	1	1	D
1023	SP2	201617	2017-02-05	Reus Deportiu	Getafe	1	1	D	0	1	A
1024	SP2	201617	2017-02-05	Vallecano	Almeria	1	0	H	1	0	H
1025	SP2	201617	2017-02-10	Sevilla B	Lugo	1	1	D	0	0	D
1026	SP2	201617	2017-02-11	Almeria	Girona	0	0	D	0	0	D
1027	SP2	201617	2017-02-11	Getafe	Cadiz	3	2	H	2	1	H
1028	SP2	201617	2017-02-11	Gimnastic	Alcorcon	1	1	D	1	1	D
1029	SP2	201617	2017-02-11	Zaragoza	Levante	0	1	A	0	1	A
1030	SP2	201617	2017-02-12	Cordoba	Huesca	0	2	A	0	0	D
1031	SP2	201617	2017-02-12	Elche	UCAM Murcia	1	1	D	1	0	H
1032	SP2	201617	2017-02-12	Mallorca	Vallecano	2	1	H	2	0	H
1033	SP2	201617	2017-02-12	Mirandes	Oviedo	0	2	A	0	1	A
1034	SP2	201617	2017-02-12	Numancia	Reus Deportiu	1	0	H	1	0	H
1035	SP2	201617	2017-02-12	Valladolid	Tenerife	0	0	D	0	0	D
1036	SP2	201617	2017-02-17	Lugo	Elche	1	2	A	1	2	A
1037	SP2	201617	2017-02-18	Gimnastic	Numancia	2	0	H	0	0	D
1038	SP2	201617	2017-02-18	Girona	Mallorca	1	0	H	0	0	D
1039	SP2	201617	2017-02-18	Levante	Cordoba	3	1	H	1	1	D
1040	SP2	201617	2017-02-18	Tenerife	Almeria	1	0	H	1	0	H
1041	SP2	201617	2017-02-18	UCAM Murcia	Valladolid	1	3	A	0	2	A
1042	SP2	201617	2017-02-19	Alcorcon	Zaragoza	1	1	D	0	0	D
1043	SP2	201617	2017-02-19	Cadiz	Reus Deportiu	0	0	D	0	0	D
1044	SP2	201617	2017-02-19	Huesca	Sevilla B	2	1	H	2	0	H
1045	SP2	201617	2017-02-19	Oviedo	Getafe	2	1	H	1	0	H
1046	SP2	201617	2017-02-19	Vallecano	Mirandes	1	2	A	0	0	D
1047	SP2	201617	2017-02-24	Reus Deportiu	Oviedo	1	1	D	1	0	H
1048	SP2	201617	2017-02-25	Cordoba	Alcorcon	1	0	H	0	0	D
1049	SP2	201617	2017-02-25	Elche	Huesca	1	1	D	0	1	A
1050	SP2	201617	2017-02-25	Getafe	Vallecano	1	0	H	0	0	D
1051	SP2	201617	2017-02-25	Mallorca	Tenerife	1	4	A	1	0	H
1052	SP2	201617	2017-02-25	Mirandes	Girona	0	2	A	0	0	D
1053	SP2	201617	2017-02-26	Almeria	UCAM Murcia	2	3	A	1	1	D
1054	SP2	201617	2017-02-26	Numancia	Cadiz	0	3	A	0	0	D
1055	SP2	201617	2017-02-26	Sevilla B	Levante	1	1	D	0	1	A
1056	SP2	201617	2017-02-26	Valladolid	Lugo	1	1	D	1	1	D
1057	SP2	201617	2017-02-26	Zaragoza	Gimnastic	1	2	A	1	1	D
1058	SP2	201617	2017-03-03	Tenerife	Mirandes	1	1	D	1	1	D
1059	SP2	201617	2017-03-04	Alcorcon	Sevilla B	0	0	D	0	0	D
1060	SP2	201617	2017-03-04	Girona	Getafe	5	1	H	3	0	H
1061	SP2	201617	2017-03-04	Oviedo	Cadiz	2	1	H	1	1	D
1062	SP2	201617	2017-03-04	Vallecano	Reus Deportiu	0	0	D	0	0	D
1063	SP2	201617	2017-03-05	Gimnastic	Cordoba	2	1	H	1	1	D
1064	SP2	201617	2017-03-05	Huesca	Valladolid	1	0	H	0	0	D
1065	SP2	201617	2017-03-05	Levante	Elche	2	1	H	0	1	A
1066	SP2	201617	2017-03-05	Lugo	Almeria	1	2	A	0	1	A
1067	SP2	201617	2017-03-05	UCAM Murcia	Mallorca	1	1	D	0	1	A
1068	SP2	201617	2017-03-05	Zaragoza	Numancia	3	0	H	2	0	H
1069	SP2	201617	2017-03-10	Elche	Alcorcon	0	0	D	0	0	D
1070	SP2	201617	2017-03-11	Cordoba	Zaragoza	2	1	H	0	1	A
1071	SP2	201617	2017-03-11	Mallorca	Lugo	1	1	D	0	1	A
1072	SP2	201617	2017-03-11	Mirandes	UCAM Murcia	1	1	D	0	0	D
1073	SP2	201617	2017-03-11	Numancia	Oviedo	0	0	D	0	0	D
1074	SP2	201617	2017-03-11	Valladolid	Levante	0	4	A	0	2	A
1075	SP2	201617	2017-03-12	Almeria	Huesca	0	0	D	0	0	D
1076	SP2	201617	2017-03-12	Cadiz	Vallecano	1	0	H	1	0	H
1077	SP2	201617	2017-03-12	Getafe	Tenerife	2	2	D	1	0	H
1078	SP2	201617	2017-03-12	Reus Deportiu	Girona	1	2	A	0	0	D
1079	SP2	201617	2017-03-12	Sevilla B	Gimnastic	2	2	D	0	1	A
1080	SP2	201617	2017-03-17	Gimnastic	Elche	1	3	A	0	3	A
1081	SP2	201617	2017-03-18	Cordoba	Numancia	0	0	D	0	0	D
1082	SP2	201617	2017-03-18	Huesca	Mallorca	2	1	H	0	0	D
1083	SP2	201617	2017-03-18	Lugo	Mirandes	2	1	H	0	0	D
1084	SP2	201617	2017-03-18	UCAM Murcia	Getafe	2	0	H	2	0	H
1085	SP2	201617	2017-03-18	Zaragoza	Sevilla B	1	2	A	0	1	A
1086	SP2	201617	2017-03-19	Alcorcon	Valladolid	1	2	A	1	2	A
1087	SP2	201617	2017-03-19	Girona	Cadiz	1	2	A	0	2	A
1088	SP2	201617	2017-03-19	Levante	Almeria	1	0	H	1	0	H
1089	SP2	201617	2017-03-19	Tenerife	Reus Deportiu	0	1	A	0	1	A
1090	SP2	201617	2017-03-19	Vallecano	Oviedo	2	0	H	1	0	H
1091	SP2	201617	2017-03-25	Almeria	Alcorcon	3	1	H	1	0	H
1092	SP2	201617	2017-03-25	Mallorca	Levante	1	1	D	0	1	A
1093	SP2	201617	2017-03-25	Numancia	Vallecano	0	0	D	0	0	D
1094	SP2	201617	2017-03-25	Oviedo	Girona	2	0	H	0	0	D
1095	SP2	201617	2017-03-25	Valladolid	Gimnastic	1	2	A	0	1	A
1096	SP2	201617	2017-03-26	Cadiz	Tenerife	0	1	A	0	0	D
1097	SP2	201617	2017-03-26	Elche	Zaragoza	0	3	A	0	3	A
1098	SP2	201617	2017-03-26	Getafe	Lugo	2	0	H	1	0	H
1099	SP2	201617	2017-03-26	Mirandes	Huesca	1	3	A	1	2	A
1100	SP2	201617	2017-03-26	Reus Deportiu	UCAM Murcia	0	0	D	0	0	D
1101	SP2	201617	2017-03-26	Sevilla B	Cordoba	1	0	H	1	0	H
1102	SP2	201617	2017-03-31	Alcorcon	Mallorca	1	0	H	0	0	D
1103	SP2	201617	2017-04-01	Girona	Vallecano	1	3	A	1	2	A
1104	SP2	201617	2017-04-01	Huesca	Getafe	0	0	D	0	0	D
1105	SP2	201617	2017-04-01	Levante	Mirandes	2	1	H	1	0	H
1106	SP2	201617	2017-04-01	UCAM Murcia	Cadiz	1	1	D	1	1	D
1107	SP2	201617	2017-04-02	Cordoba	Elche	1	0	H	0	0	D
1108	SP2	201617	2017-04-02	Gimnastic	Almeria	0	1	A	0	0	D
1109	SP2	201617	2017-04-02	Lugo	Reus Deportiu	1	0	H	0	0	D
1110	SP2	201617	2017-04-02	Tenerife	Oviedo	1	0	H	1	0	H
1111	SP2	201617	2017-04-02	Zaragoza	Valladolid	1	1	D	1	1	D
1112	SP2	201617	2017-04-03	Sevilla B	Numancia	1	1	D	1	1	D
1113	SP2	201617	2017-04-07	Mirandes	Alcorcon	2	0	H	0	0	D
1114	SP2	201617	2017-04-08	Cadiz	Lugo	1	1	D	1	1	D
1115	SP2	201617	2017-04-08	Getafe	Levante	2	0	H	2	0	H
1116	SP2	201617	2017-04-08	Mallorca	Gimnastic	0	0	D	0	0	D
1117	SP2	201617	2017-04-08	Vallecano	Tenerife	1	1	D	1	1	D
1118	SP2	201617	2017-04-09	Almeria	Zaragoza	2	2	D	2	2	D
1119	SP2	201617	2017-04-09	Elche	Sevilla B	3	2	H	1	1	D
1120	SP2	201617	2017-04-09	Numancia	Girona	0	2	A	0	0	D
1121	SP2	201617	2017-04-09	Oviedo	UCAM Murcia	2	0	H	1	0	H
1122	SP2	201617	2017-04-09	Reus Deportiu	Huesca	0	1	A	0	0	D
1123	SP2	201617	2017-04-09	Valladolid	Cordoba	2	1	H	1	0	H
1124	SP2	201617	2017-04-15	Elche	Numancia	1	3	A	0	1	A
1125	SP2	201617	2017-04-15	Gimnastic	Mirandes	4	1	H	1	1	D
1126	SP2	201617	2017-04-15	Huesca	Cadiz	1	1	D	0	0	D
1127	SP2	201617	2017-04-15	Tenerife	Girona	3	3	D	1	2	A
1128	SP2	201617	2017-04-16	Alcorcon	Getafe	0	3	A	0	2	A
1129	SP2	201617	2017-04-16	Cordoba	Almeria	1	0	H	1	0	H
1130	SP2	201617	2017-04-16	Lugo	Oviedo	2	1	H	1	1	D
1131	SP2	201617	2017-04-16	Sevilla B	Valladolid	6	2	H	4	0	H
1132	SP2	201617	2017-04-16	UCAM Murcia	Vallecano	0	1	A	0	1	A
1133	SP2	201617	2017-04-16	Zaragoza	Mallorca	1	0	H	1	0	H
1134	SP2	201617	2017-04-17	Levante	Reus Deportiu	0	0	D	0	0	D
1135	SP2	201617	2017-04-21	Oviedo	Huesca	1	1	D	1	0	H
1136	SP2	201617	2017-04-22	Cadiz	Levante	1	1	D	0	1	A
1137	SP2	201617	2017-04-22	Getafe	Gimnastic	1	1	D	1	0	H
1138	SP2	201617	2017-04-22	Girona	UCAM Murcia	1	2	A	1	1	D
1139	SP2	201617	2017-04-22	Valladolid	Elche	2	1	H	1	1	D
1140	SP2	201617	2017-04-22	Vallecano	Lugo	2	0	H	0	0	D
1141	SP2	201617	2017-04-23	Almeria	Sevilla B	2	1	H	1	0	H
1142	SP2	201617	2017-04-23	Mallorca	Cordoba	1	1	D	1	1	D
1143	SP2	201617	2017-04-23	Mirandes	Zaragoza	0	1	A	0	1	A
1144	SP2	201617	2017-04-23	Numancia	Tenerife	1	1	D	0	0	D
1145	SP2	201617	2017-04-23	Reus Deportiu	Alcorcon	0	0	D	0	0	D
1146	SP2	201617	2017-04-28	Elche	Almeria	2	3	A	0	1	A
1147	SP2	201617	2017-04-29	Levante	Oviedo	1	0	H	0	0	D
1148	SP2	201617	2017-04-29	UCAM Murcia	Tenerife	1	0	H	1	0	H
1149	SP2	201617	2017-04-29	Valladolid	Numancia	1	1	D	0	0	D
1150	SP2	201617	2017-04-29	Zaragoza	Getafe	1	2	A	1	0	H
1151	SP2	201617	2017-04-30	Alcorcon	Cadiz	0	2	A	0	1	A
1152	SP2	201617	2017-04-30	Cordoba	Mirandes	1	1	D	0	0	D
1153	SP2	201617	2017-04-30	Lugo	Girona	1	2	A	0	2	A
1154	SP2	201617	2017-04-30	Sevilla B	Mallorca	2	3	A	0	1	A
1155	SP2	201617	2017-05-01	Gimnastic	Reus Deportiu	0	1	A	0	0	D
1156	SP2	201617	2017-05-01	Huesca	Vallecano	2	0	H	0	0	D
1157	SP2	201617	2017-05-05	Oviedo	Alcorcon	0	1	A	0	0	D
1158	SP2	201617	2017-05-06	Girona	Huesca	3	1	H	2	1	H
1159	SP2	201617	2017-05-06	Mallorca	Elche	1	0	H	0	0	D
1160	SP2	201617	2017-05-06	Numancia	UCAM Murcia	1	0	H	1	0	H
1161	SP2	201617	2017-05-06	Vallecano	Levante	2	1	H	1	1	D
1162	SP2	201617	2017-05-07	Almeria	Valladolid	0	3	A	0	1	A
1163	SP2	201617	2017-05-07	Cadiz	Gimnastic	0	0	D	0	0	D
1164	SP2	201617	2017-05-07	Getafe	Cordoba	2	0	H	1	0	H
1165	SP2	201617	2017-05-07	Mirandes	Sevilla B	0	1	A	0	0	D
1166	SP2	201617	2017-05-07	Reus Deportiu	Zaragoza	1	0	H	1	0	H
1167	SP2	201617	2017-05-07	Tenerife	Lugo	2	1	H	1	0	H
1168	SP2	201617	2017-05-12	Sevilla B	Getafe	2	1	H	1	0	H
1169	SP2	201617	2017-05-12	Zaragoza	Cadiz	1	1	D	1	0	H
1170	SP2	201617	2017-05-13	Alcorcon	Vallecano	2	0	H	0	0	D
1171	SP2	201617	2017-05-13	Almeria	Numancia	2	0	H	2	0	H
1172	SP2	201617	2017-05-13	Cordoba	Reus Deportiu	1	0	H	0	0	D
1173	SP2	201617	2017-05-13	Elche	Mirandes	0	1	A	0	0	D
1174	SP2	201617	2017-05-13	Gimnastic	Oviedo	2	2	D	0	2	A
1175	SP2	201617	2017-05-13	Huesca	Tenerife	2	2	D	0	2	A
1176	SP2	201617	2017-05-13	Levante	Girona	2	1	H	1	0	H
1177	SP2	201617	2017-05-13	Valladolid	Mallorca	2	1	H	1	0	H
1178	SP2	201617	2017-05-14	Lugo	UCAM Murcia	0	0	D	0	0	D
1179	SP2	201617	2017-05-19	Getafe	Elche	2	0	H	1	0	H
1180	SP2	201617	2017-05-19	Vallecano	Gimnastic	2	0	H	0	0	D
1181	SP2	201617	2017-05-20	Cadiz	Cordoba	1	1	D	0	0	D
1182	SP2	201617	2017-05-20	Girona	Alcorcon	0	0	D	0	0	D
1183	SP2	201617	2017-05-20	Mallorca	Almeria	1	0	H	1	0	H
1184	SP2	201617	2017-05-20	Oviedo	Zaragoza	0	0	D	0	0	D
1185	SP2	201617	2017-05-20	Reus Deportiu	Sevilla B	2	1	H	1	0	H
1186	SP2	201617	2017-05-20	Tenerife	Levante	0	0	D	0	0	D
1187	SP2	201617	2017-05-20	UCAM Murcia	Huesca	3	1	H	2	0	H
1188	SP2	201617	2017-05-21	Mirandes	Valladolid	2	2	D	0	2	A
1189	SP2	201617	2017-05-21	Numancia	Lugo	0	1	A	0	0	D
1190	SP2	201617	2017-05-26	Levante	UCAM Murcia	3	1	H	1	1	D
1191	SP2	201617	2017-05-27	Almeria	Mirandes	2	0	H	1	0	H
1192	SP2	201617	2017-05-27	Huesca	Lugo	1	0	H	1	0	H
1193	SP2	201617	2017-05-27	Sevilla B	Cadiz	3	3	D	2	0	H
1194	SP2	201617	2017-05-27	Valladolid	Getafe	1	0	H	0	0	D
1195	SP2	201617	2017-05-28	Alcorcon	Tenerife	1	3	A	0	2	A
1196	SP2	201617	2017-05-28	Cordoba	Oviedo	4	2	H	3	0	H
1197	SP2	201617	2017-05-28	Elche	Reus Deportiu	1	1	D	0	0	D
1198	SP2	201617	2017-05-28	Gimnastic	Girona	3	1	H	0	1	A
1199	SP2	201617	2017-05-28	Mallorca	Numancia	0	0	D	0	0	D
1200	SP2	201617	2017-05-28	Zaragoza	Vallecano	1	1	D	1	0	H
1201	SP2	201617	2017-06-02	Lugo	Levante	1	0	H	0	0	D
1202	SP2	201617	2017-06-04	Cadiz	Elche	2	1	H	0	0	D
1203	SP2	201617	2017-06-04	Getafe	Almeria	4	0	H	2	0	H
1204	SP2	201617	2017-06-04	Girona	Zaragoza	0	0	D	0	0	D
1205	SP2	201617	2017-06-04	Huesca	Numancia	0	0	D	0	0	D
1206	SP2	201617	2017-06-04	Mirandes	Mallorca	2	2	D	2	1	H
1207	SP2	201617	2017-06-04	Oviedo	Sevilla B	1	0	H	1	0	H
1208	SP2	201617	2017-06-04	Reus Deportiu	Valladolid	2	0	H	2	0	H
1209	SP2	201617	2017-06-04	Tenerife	Gimnastic	0	1	A	0	0	D
1210	SP2	201617	2017-06-04	UCAM Murcia	Alcorcon	0	1	A	0	1	A
1211	SP2	201617	2017-06-04	Vallecano	Cordoba	1	2	A	1	1	D
1212	SP2	201617	2017-06-09	Sevilla B	Vallecano	1	2	A	0	1	A
1213	SP2	201617	2017-06-10	Alcorcon	Lugo	3	0	H	1	0	H
1214	SP2	201617	2017-06-10	Almeria	Reus Deportiu	1	0	H	1	0	H
1215	SP2	201617	2017-06-10	Cordoba	Girona	2	1	H	0	0	D
1216	SP2	201617	2017-06-10	Elche	Oviedo	0	2	A	0	0	D
1217	SP2	201617	2017-06-10	Gimnastic	UCAM Murcia	1	0	H	0	0	D
1218	SP2	201617	2017-06-10	Levante	Huesca	1	2	A	0	0	D
1219	SP2	201617	2017-06-10	Mallorca	Getafe	3	3	D	1	1	D
1220	SP2	201617	2017-06-10	Valladolid	Cadiz	1	0	H	0	0	D
1221	SP2	201617	2017-06-10	Zaragoza	Tenerife	1	2	A	0	1	A
1222	SP2	201617	2017-06-11	Numancia	Mirandes	0	2	A	0	0	D
1223	SP2	201516	2015-08-22	Alcorcon	Mallorca	2	0	H	1	0	H
1224	SP2	201516	2015-08-22	Cordoba	Valladolid	1	0	H	0	0	D
1225	SP2	201516	2015-08-22	Huesca	Alaves	2	3	A	0	1	A
1226	SP2	201516	2015-08-22	Llagostera	Osasuna	0	2	A	0	0	D
1227	SP2	201516	2015-08-23	Almeria	Leganes	3	2	H	3	0	H
1228	SP2	201516	2015-08-23	Gimnastic	Albacete	2	2	D	0	0	D
1229	SP2	201516	2015-08-23	Mirandes	Zaragoza	1	1	D	0	0	D
1230	SP2	201516	2015-08-23	Numancia	Tenerife	6	3	H	1	2	A
1231	SP2	201516	2015-08-23	Oviedo	Lugo	2	2	D	1	1	D
1232	SP2	201516	2015-08-23	Ponferradina	Elche	2	0	H	0	0	D
1233	SP2	201516	2015-08-24	Ath Bilbao B	Girona	0	1	A	0	0	D
1234	SP2	201516	2015-08-29	Albacete	Huesca	1	1	D	1	1	D
1235	SP2	201516	2015-08-29	Girona	Numancia	2	3	A	1	1	D
1236	SP2	201516	2015-08-29	Leganes	Cordoba	3	1	H	2	0	H
1237	SP2	201516	2015-08-29	Lugo	Llagostera	1	0	H	0	0	D
1238	SP2	201516	2015-08-29	Zaragoza	Almeria	3	2	H	1	1	D
1239	SP2	201516	2015-08-30	Alaves	Oviedo	2	0	H	2	0	H
1240	SP2	201516	2015-08-30	Elche	Ath Bilbao B	2	1	H	0	0	D
1241	SP2	201516	2015-08-30	Mallorca	Ponferradina	1	0	H	1	0	H
1242	SP2	201516	2015-08-30	Osasuna	Mirandes	1	0	H	0	0	D
1243	SP2	201516	2015-08-30	Tenerife	Gimnastic	1	2	A	0	0	D
1244	SP2	201516	2015-08-30	Valladolid	Alcorcon	2	0	H	0	0	D
1245	SP2	201516	2015-09-05	Gimnastic	Girona	1	0	H	0	0	D
1246	SP2	201516	2015-09-05	Huesca	Tenerife	1	1	D	1	1	D
1247	SP2	201516	2015-09-05	Mirandes	Lugo	1	1	D	0	1	A
1248	SP2	201516	2015-09-05	Numancia	Elche	0	0	D	0	0	D
1249	SP2	201516	2015-09-06	Almeria	Osasuna	2	1	H	0	1	A
1250	SP2	201516	2015-09-06	Ath Bilbao B	Mallorca	3	1	H	1	1	D
1251	SP2	201516	2015-09-06	Cordoba	Alcorcon	1	3	A	1	1	D
1252	SP2	201516	2015-09-06	Leganes	Zaragoza	1	1	D	1	0	H
1253	SP2	201516	2015-09-06	Llagostera	Alaves	3	0	H	1	0	H
1254	SP2	201516	2015-09-06	Oviedo	Albacete	3	1	H	2	1	H
1255	SP2	201516	2015-09-06	Ponferradina	Valladolid	3	0	H	1	0	H
1256	SP2	201516	2015-09-12	Alaves	Mirandes	2	3	A	0	2	A
1257	SP2	201516	2015-09-12	Elche	Gimnastic	1	0	H	1	0	H
1258	SP2	201516	2015-09-12	Osasuna	Leganes	2	1	H	1	0	H
1259	SP2	201516	2015-09-12	Valladolid	Ath Bilbao B	1	0	H	1	0	H
1260	SP2	201516	2015-09-12	Zaragoza	Cordoba	0	1	A	0	1	A
1261	SP2	201516	2015-09-13	Albacete	Llagostera	1	0	H	1	0	H
1262	SP2	201516	2015-09-13	Alcorcon	Ponferradina	1	0	H	0	0	D
1263	SP2	201516	2015-09-13	Girona	Huesca	0	0	D	0	0	D
1264	SP2	201516	2015-09-13	Lugo	Almeria	1	0	H	0	0	D
1265	SP2	201516	2015-09-13	Mallorca	Numancia	0	0	D	0	0	D
1266	SP2	201516	2015-09-13	Tenerife	Oviedo	0	2	A	0	1	A
1267	SP2	201516	2015-09-19	Ath Bilbao B	Alcorcon	1	0	H	0	0	D
1268	SP2	201516	2015-09-19	Leganes	Lugo	0	0	D	0	0	D
1269	SP2	201516	2015-09-19	Llagostera	Tenerife	0	2	A	0	0	D
1270	SP2	201516	2015-09-19	Mirandes	Albacete	1	1	D	1	0	H
1271	SP2	201516	2015-09-19	Oviedo	Girona	1	2	A	1	1	D
1272	SP2	201516	2015-09-20	Almeria	Alaves	0	2	A	0	1	A
1273	SP2	201516	2015-09-20	Cordoba	Ponferradina	1	0	H	1	0	H
1274	SP2	201516	2015-09-20	Gimnastic	Mallorca	1	0	H	1	0	H
1275	SP2	201516	2015-09-20	Huesca	Elche	1	3	A	0	1	A
1276	SP2	201516	2015-09-20	Numancia	Valladolid	2	2	D	0	1	A
1277	SP2	201516	2015-09-20	Zaragoza	Osasuna	0	1	A	0	1	A
1278	SP2	201516	2015-09-26	Alcorcon	Numancia	1	1	D	1	1	D
1279	SP2	201516	2015-09-26	Lugo	Zaragoza	0	0	D	0	0	D
1280	SP2	201516	2015-09-26	Mallorca	Huesca	0	1	A	0	0	D
1281	SP2	201516	2015-09-26	Osasuna	Cordoba	0	0	D	0	0	D
1282	SP2	201516	2015-09-26	Ponferradina	Ath Bilbao B	1	0	H	0	0	D
1283	SP2	201516	2015-09-27	Alaves	Leganes	0	0	D	0	0	D
1284	SP2	201516	2015-09-27	Albacete	Almeria	3	0	H	2	0	H
1285	SP2	201516	2015-09-27	Elche	Oviedo	1	1	D	1	0	H
1286	SP2	201516	2015-09-27	Girona	Llagostera	2	2	D	1	0	H
1287	SP2	201516	2015-09-27	Tenerife	Mirandes	3	0	H	1	0	H
1288	SP2	201516	2015-09-27	Valladolid	Gimnastic	0	0	D	0	0	D
1289	SP2	201516	2015-10-03	Almeria	Tenerife	2	2	D	0	1	A
1290	SP2	201516	2015-10-03	Cordoba	Ath Bilbao B	1	0	H	1	0	H
1291	SP2	201516	2015-10-03	Gimnastic	Alcorcon	0	2	A	0	0	D
1292	SP2	201516	2015-10-03	Numancia	Ponferradina	1	0	H	1	0	H
1293	SP2	201516	2015-10-03	Zaragoza	Alaves	1	0	H	1	0	H
1294	SP2	201516	2015-10-04	Huesca	Valladolid	1	1	D	0	1	A
1295	SP2	201516	2015-10-04	Leganes	Albacete	3	2	H	0	1	A
1296	SP2	201516	2015-10-04	Llagostera	Elche	4	1	H	2	0	H
1297	SP2	201516	2015-10-04	Mirandes	Girona	1	0	H	0	0	D
1298	SP2	201516	2015-10-04	Osasuna	Lugo	4	0	H	3	0	H
1299	SP2	201516	2015-10-04	Oviedo	Mallorca	1	1	D	1	1	D
1300	SP2	201516	2015-10-10	Alaves	Osasuna	3	0	H	1	0	H
1301	SP2	201516	2015-10-10	Ath Bilbao B	Numancia	0	0	D	0	0	D
1302	SP2	201516	2015-10-10	Elche	Mirandes	1	4	A	0	0	D
1303	SP2	201516	2015-10-10	Ponferradina	Gimnastic	2	2	D	0	0	D
1304	SP2	201516	2015-10-10	Tenerife	Leganes	0	0	D	0	0	D
1305	SP2	201516	2015-10-11	Albacete	Zaragoza	1	3	A	0	3	A
1306	SP2	201516	2015-10-11	Alcorcon	Huesca	0	1	A	0	0	D
1307	SP2	201516	2015-10-11	Girona	Almeria	1	1	D	1	1	D
1308	SP2	201516	2015-10-11	Lugo	Cordoba	1	2	A	1	1	D
1309	SP2	201516	2015-10-11	Mallorca	Llagostera	1	0	H	0	0	D
1310	SP2	201516	2015-10-11	Valladolid	Oviedo	2	3	A	1	2	A
1311	SP2	201516	2015-10-17	Gimnastic	Ath Bilbao B	2	1	H	1	0	H
1312	SP2	201516	2015-10-17	Leganes	Girona	2	2	D	1	0	H
1313	SP2	201516	2015-10-17	Mirandes	Mallorca	2	2	D	2	0	H
1314	SP2	201516	2015-10-17	Osasuna	Albacete	1	0	H	1	0	H
1315	SP2	201516	2015-10-17	Oviedo	Alcorcon	3	2	H	1	0	H
1316	SP2	201516	2015-10-18	Almeria	Elche	2	3	A	1	1	D
1317	SP2	201516	2015-10-18	Cordoba	Numancia	3	2	H	2	1	H
1318	SP2	201516	2015-10-18	Huesca	Ponferradina	1	1	D	1	0	H
1319	SP2	201516	2015-10-18	Llagostera	Valladolid	3	1	H	1	0	H
1320	SP2	201516	2015-10-18	Lugo	Alaves	1	0	H	1	0	H
1321	SP2	201516	2015-10-18	Zaragoza	Tenerife	2	0	H	1	0	H
1322	SP2	201516	2015-10-24	Alaves	Cordoba	3	2	H	1	2	A
1323	SP2	201516	2015-10-24	Alcorcon	Llagostera	6	1	H	5	0	H
1324	SP2	201516	2015-10-24	Ath Bilbao B	Huesca	0	0	D	0	0	D
1325	SP2	201516	2015-10-24	Elche	Leganes	0	0	D	0	0	D
1326	SP2	201516	2015-10-24	Girona	Zaragoza	0	0	D	0	0	D
1327	SP2	201516	2015-10-25	Albacete	Lugo	2	0	H	1	0	H
1328	SP2	201516	2015-10-25	Mallorca	Almeria	1	0	H	0	0	D
1329	SP2	201516	2015-10-25	Numancia	Gimnastic	1	1	D	0	0	D
1330	SP2	201516	2015-10-25	Ponferradina	Oviedo	4	2	H	2	1	H
1331	SP2	201516	2015-10-25	Tenerife	Osasuna	2	2	D	1	1	D
1332	SP2	201516	2015-10-25	Valladolid	Mirandes	2	1	H	2	0	H
1333	SP2	201516	2015-10-31	Cordoba	Gimnastic	2	0	H	2	0	H
1334	SP2	201516	2015-10-31	Huesca	Numancia	2	0	H	1	0	H
1335	SP2	201516	2015-10-31	Llagostera	Ponferradina	0	1	A	0	0	D
1336	SP2	201516	2015-10-31	Lugo	Tenerife	2	0	H	2	0	H
1337	SP2	201516	2015-10-31	Mirandes	Alcorcon	3	0	H	2	0	H
1338	SP2	201516	2015-11-01	Alaves	Albacete	1	1	D	1	1	D
1339	SP2	201516	2015-11-01	Almeria	Valladolid	1	1	D	0	0	D
1340	SP2	201516	2015-11-01	Leganes	Mallorca	0	0	D	0	0	D
1341	SP2	201516	2015-11-01	Osasuna	Girona	0	1	A	0	1	A
1342	SP2	201516	2015-11-01	Oviedo	Ath Bilbao B	0	0	D	0	0	D
1343	SP2	201516	2015-11-01	Zaragoza	Elche	2	0	H	0	0	D
1344	SP2	201516	2015-11-07	Mallorca	Zaragoza	0	0	D	0	0	D
1345	SP2	201516	2015-11-07	Ponferradina	Mirandes	2	2	D	1	1	D
1346	SP2	201516	2015-11-07	Tenerife	Alaves	2	0	H	0	0	D
1347	SP2	201516	2015-11-07	Valladolid	Leganes	1	1	D	1	0	H
1348	SP2	201516	2015-11-08	Albacete	Cordoba	2	0	H	0	0	D
1349	SP2	201516	2015-11-08	Alcorcon	Almeria	0	0	D	0	0	D
1350	SP2	201516	2015-11-08	Elche	Osasuna	2	1	H	1	1	D
1351	SP2	201516	2015-11-08	Gimnastic	Huesca	2	0	H	2	0	H
1352	SP2	201516	2015-11-08	Girona	Lugo	0	1	A	0	0	D
1353	SP2	201516	2015-11-08	Numancia	Oviedo	1	0	H	0	0	D
1354	SP2	201516	2015-11-09	Ath Bilbao B	Llagostera	2	0	H	1	0	H
1355	SP2	201516	2015-11-14	Alaves	Girona	1	0	H	1	0	H
1356	SP2	201516	2015-11-14	Albacete	Tenerife	1	2	A	1	1	D
1357	SP2	201516	2015-11-14	Leganes	Alcorcon	3	0	H	2	0	H
1358	SP2	201516	2015-11-14	Lugo	Elche	1	1	D	1	0	H
1359	SP2	201516	2015-11-14	Mirandes	Ath Bilbao B	3	0	H	2	0	H
1360	SP2	201516	2015-11-15	Almeria	Ponferradina	1	1	D	1	1	D
1361	SP2	201516	2015-11-15	Cordoba	Huesca	1	1	D	0	0	D
1362	SP2	201516	2015-11-15	Llagostera	Numancia	2	1	H	2	0	H
1363	SP2	201516	2015-11-15	Osasuna	Mallorca	2	1	H	2	1	H
1364	SP2	201516	2015-11-15	Oviedo	Gimnastic	2	0	H	2	0	H
1365	SP2	201516	2015-11-15	Zaragoza	Valladolid	0	2	A	0	1	A
1366	SP2	201516	2015-11-21	Ath Bilbao B	Almeria	0	0	D	0	0	D
1367	SP2	201516	2015-11-21	Elche	Alaves	0	1	A	0	0	D
1368	SP2	201516	2015-11-21	Huesca	Oviedo	0	1	A	0	0	D
1369	SP2	201516	2015-11-21	Mallorca	Lugo	1	1	D	0	0	D
1370	SP2	201516	2015-11-21	Numancia	Mirandes	2	2	D	0	1	A
1371	SP2	201516	2015-11-22	Alcorcon	Zaragoza	1	0	H	1	0	H
1372	SP2	201516	2015-11-22	Gimnastic	Llagostera	2	0	H	1	0	H
1373	SP2	201516	2015-11-22	Girona	Albacete	3	0	H	2	0	H
1374	SP2	201516	2015-11-22	Ponferradina	Leganes	1	0	H	0	0	D
1375	SP2	201516	2015-11-22	Tenerife	Cordoba	1	1	D	0	0	D
1376	SP2	201516	2015-11-22	Valladolid	Osasuna	0	1	A	0	0	D
1377	SP2	201516	2015-11-28	Alaves	Mallorca	1	0	H	1	0	H
1378	SP2	201516	2015-11-28	Almeria	Numancia	1	1	D	1	0	H
1379	SP2	201516	2015-11-28	Leganes	Ath Bilbao B	1	0	H	1	0	H
1380	SP2	201516	2015-11-28	Llagostera	Huesca	2	0	H	1	0	H
1381	SP2	201516	2015-11-28	Osasuna	Alcorcon	1	2	A	0	1	A
1382	SP2	201516	2015-11-29	Albacete	Elche	1	0	H	0	0	D
1383	SP2	201516	2015-11-29	Cordoba	Oviedo	2	1	H	2	1	H
1384	SP2	201516	2015-11-29	Lugo	Valladolid	1	1	D	0	0	D
1385	SP2	201516	2015-11-29	Mirandes	Gimnastic	0	1	A	0	0	D
1386	SP2	201516	2015-11-29	Tenerife	Girona	1	1	D	1	1	D
1387	SP2	201516	2015-11-29	Zaragoza	Ponferradina	2	0	H	2	0	H
1388	SP2	201516	2015-12-05	Alcorcon	Lugo	1	1	D	0	1	A
1389	SP2	201516	2015-12-05	Elche	Tenerife	0	0	D	0	0	D
1390	SP2	201516	2015-12-05	Gimnastic	Almeria	2	2	D	2	1	H
1391	SP2	201516	2015-12-05	Valladolid	Alaves	1	2	A	0	1	A
1392	SP2	201516	2015-12-06	Girona	Cordoba	1	2	A	0	0	D
1393	SP2	201516	2015-12-06	Huesca	Mirandes	1	2	A	0	1	A
1394	SP2	201516	2015-12-06	Mallorca	Albacete	2	0	H	0	0	D
1395	SP2	201516	2015-12-06	Numancia	Leganes	1	2	A	0	1	A
1396	SP2	201516	2015-12-06	Oviedo	Llagostera	2	1	H	2	1	H
1397	SP2	201516	2015-12-06	Ponferradina	Osasuna	3	0	H	2	0	H
1398	SP2	201516	2015-12-07	Ath Bilbao B	Zaragoza	0	1	A	0	1	A
1399	SP2	201516	2015-12-12	Alaves	Alcorcon	1	1	D	0	0	D
1400	SP2	201516	2015-12-12	Cordoba	Llagostera	2	0	H	1	0	H
1401	SP2	201516	2015-12-12	Girona	Elche	0	1	A	0	1	A
1402	SP2	201516	2015-12-12	Lugo	Ponferradina	3	1	H	1	1	D
1403	SP2	201516	2015-12-12	Tenerife	Mallorca	2	1	H	0	1	A
1404	SP2	201516	2015-12-13	Albacete	Valladolid	0	1	A	0	1	A
1405	SP2	201516	2015-12-13	Almeria	Huesca	1	2	A	0	2	A
1406	SP2	201516	2015-12-13	Leganes	Gimnastic	1	0	H	1	0	H
1407	SP2	201516	2015-12-13	Mirandes	Oviedo	1	2	A	1	0	H
1408	SP2	201516	2015-12-13	Osasuna	Ath Bilbao B	1	1	D	0	1	A
1409	SP2	201516	2015-12-13	Zaragoza	Numancia	2	2	D	1	0	H
1410	SP2	201516	2015-12-18	Elche	Cordoba	2	1	H	2	1	H
1411	SP2	201516	2015-12-19	Gimnastic	Zaragoza	3	1	H	1	0	H
1412	SP2	201516	2015-12-19	Mallorca	Girona	1	1	D	1	0	H
1413	SP2	201516	2015-12-19	Numancia	Osasuna	1	3	A	0	0	D
1414	SP2	201516	2015-12-19	Ponferradina	Alaves	0	1	A	0	0	D
1415	SP2	201516	2015-12-20	Alcorcon	Albacete	1	0	H	1	0	H
1416	SP2	201516	2015-12-20	Huesca	Leganes	1	1	D	0	0	D
1417	SP2	201516	2015-12-20	Llagostera	Mirandes	0	0	D	0	0	D
1418	SP2	201516	2015-12-20	Oviedo	Almeria	1	0	H	1	0	H
1419	SP2	201516	2015-12-20	Valladolid	Tenerife	4	1	H	2	1	H
1420	SP2	201516	2015-12-21	Ath Bilbao B	Lugo	1	1	D	1	1	D
1421	SP2	201516	2016-01-02	Alaves	Ath Bilbao B	3	0	H	2	0	H
1422	SP2	201516	2016-01-02	Elche	Mallorca	1	1	D	1	0	H
1423	SP2	201516	2016-01-02	Osasuna	Gimnastic	1	1	D	0	0	D
1424	SP2	201516	2016-01-03	Albacete	Ponferradina	2	2	D	1	0	H
1425	SP2	201516	2016-01-03	Almeria	Llagostera	2	1	H	0	0	D
1426	SP2	201516	2016-01-03	Cordoba	Mirandes	1	2	A	0	1	A
1427	SP2	201516	2016-01-03	Leganes	Oviedo	1	1	D	1	0	H
1428	SP2	201516	2016-01-03	Lugo	Numancia	2	3	A	1	1	D
1429	SP2	201516	2016-01-03	Zaragoza	Huesca	3	3	D	1	0	H
1430	SP2	201516	2016-01-04	Girona	Valladolid	1	0	H	0	0	D
1431	SP2	201516	2016-01-04	Tenerife	Alcorcon	1	2	A	0	2	A
1432	SP2	201516	2016-01-09	Alcorcon	Girona	1	0	H	1	0	H
1433	SP2	201516	2016-01-09	Ath Bilbao B	Albacete	0	1	A	0	0	D
1434	SP2	201516	2016-01-09	Gimnastic	Lugo	1	2	A	0	0	D
1435	SP2	201516	2016-01-09	Numancia	Alaves	0	1	A	0	0	D
1436	SP2	201516	2016-01-09	Valladolid	Elche	1	1	D	0	0	D
1437	SP2	201516	2016-01-10	Cordoba	Mallorca	3	1	H	2	0	H
1438	SP2	201516	2016-01-10	Huesca	Osasuna	0	1	A	0	1	A
1439	SP2	201516	2016-01-10	Llagostera	Leganes	0	1	A	0	1	A
1440	SP2	201516	2016-01-10	Mirandes	Almeria	1	1	D	0	0	D
1441	SP2	201516	2016-01-10	Oviedo	Zaragoza	1	0	H	1	0	H
1442	SP2	201516	2016-01-10	Ponferradina	Tenerife	0	1	A	0	0	D
1443	SP2	201516	2016-01-16	Albacete	Numancia	0	2	A	0	1	A
1444	SP2	201516	2016-01-16	Elche	Alcorcon	2	0	H	1	0	H
1445	SP2	201516	2016-01-16	Osasuna	Oviedo	0	0	D	0	0	D
1446	SP2	201516	2016-01-16	Tenerife	Ath Bilbao B	2	0	H	2	0	H
1447	SP2	201516	2016-01-16	Zaragoza	Llagostera	1	0	H	1	0	H
1448	SP2	201516	2016-01-17	Alaves	Gimnastic	1	3	A	0	1	A
1449	SP2	201516	2016-01-17	Almeria	Cordoba	0	1	A	0	0	D
1450	SP2	201516	2016-01-17	Girona	Ponferradina	4	0	H	1	0	H
1451	SP2	201516	2016-01-17	Leganes	Mirandes	4	0	H	3	0	H
1452	SP2	201516	2016-01-17	Lugo	Huesca	1	1	D	1	0	H
1453	SP2	201516	2016-01-17	Mallorca	Valladolid	0	1	A	0	0	D
1454	SP2	201516	2016-01-23	Alaves	Huesca	1	0	H	1	0	H
1455	SP2	201516	2016-01-23	Girona	Ath Bilbao B	2	1	H	1	1	D
1456	SP2	201516	2016-01-23	Leganes	Almeria	2	1	H	2	0	H
1457	SP2	201516	2016-01-23	Lugo	Oviedo	2	2	D	2	2	D
1458	SP2	201516	2016-01-23	Mallorca	Alcorcon	1	0	H	0	0	D
1459	SP2	201516	2016-01-24	Albacete	Gimnastic	1	1	D	0	0	D
1460	SP2	201516	2016-01-24	Elche	Ponferradina	1	0	H	0	0	D
1461	SP2	201516	2016-01-24	Osasuna	Llagostera	3	0	H	1	0	H
1462	SP2	201516	2016-01-24	Tenerife	Numancia	0	0	D	0	0	D
1463	SP2	201516	2016-01-24	Valladolid	Cordoba	2	0	H	2	0	H
1464	SP2	201516	2016-01-24	Zaragoza	Mirandes	1	2	A	1	1	D
1465	SP2	201516	2016-01-30	Alcorcon	Valladolid	0	0	D	0	0	D
1466	SP2	201516	2016-01-30	Cordoba	Leganes	2	3	A	1	0	H
1467	SP2	201516	2016-01-30	Huesca	Albacete	3	1	H	1	0	H
1468	SP2	201516	2016-01-30	Llagostera	Lugo	0	0	D	0	0	D
1469	SP2	201516	2016-01-30	Oviedo	Alaves	1	1	D	1	0	H
1470	SP2	201516	2016-01-31	Almeria	Zaragoza	2	1	H	0	0	D
1471	SP2	201516	2016-01-31	Ath Bilbao B	Elche	0	1	A	0	0	D
1472	SP2	201516	2016-01-31	Gimnastic	Tenerife	2	1	H	2	0	H
1473	SP2	201516	2016-01-31	Mirandes	Osasuna	4	0	H	0	0	D
1474	SP2	201516	2016-01-31	Numancia	Girona	1	1	D	1	0	H
1475	SP2	201516	2016-01-31	Ponferradina	Mallorca	0	2	A	0	0	D
1476	SP2	201516	2016-02-06	Albacete	Oviedo	2	2	D	2	0	H
1477	SP2	201516	2016-02-06	Elche	Numancia	0	0	D	0	0	D
1478	SP2	201516	2016-02-06	Tenerife	Huesca	1	1	D	1	0	H
1479	SP2	201516	2016-02-06	Valladolid	Ponferradina	0	0	D	0	0	D
1480	SP2	201516	2016-02-06	Zaragoza	Leganes	1	0	H	0	0	D
1481	SP2	201516	2016-02-07	Alaves	Llagostera	1	0	H	0	0	D
1482	SP2	201516	2016-02-07	Alcorcon	Cordoba	3	3	D	2	2	D
1483	SP2	201516	2016-02-07	Girona	Gimnastic	1	1	D	0	1	A
1484	SP2	201516	2016-02-07	Lugo	Mirandes	1	4	A	0	1	A
1485	SP2	201516	2016-02-07	Mallorca	Ath Bilbao B	2	3	A	1	1	D
1486	SP2	201516	2016-02-07	Osasuna	Almeria	0	0	D	0	0	D
1487	SP2	201516	2016-02-13	Almeria	Lugo	0	2	A	0	0	D
1488	SP2	201516	2016-02-13	Ath Bilbao B	Valladolid	0	1	A	0	1	A
1489	SP2	201516	2016-02-13	Gimnastic	Elche	1	0	H	1	0	H
1490	SP2	201516	2016-02-13	Mirandes	Alaves	0	0	D	0	0	D
1491	SP2	201516	2016-02-13	Ponferradina	Alcorcon	0	0	D	0	0	D
1492	SP2	201516	2016-02-14	Cordoba	Zaragoza	0	2	A	0	1	A
1493	SP2	201516	2016-02-14	Huesca	Girona	0	1	A	0	1	A
1494	SP2	201516	2016-02-14	Leganes	Osasuna	2	0	H	1	0	H
1495	SP2	201516	2016-02-14	Llagostera	Albacete	2	0	H	0	0	D
1496	SP2	201516	2016-02-14	Numancia	Mallorca	2	0	H	1	0	H
1497	SP2	201516	2016-02-14	Oviedo	Tenerife	1	0	H	1	0	H
1498	SP2	201516	2016-02-20	Albacete	Mirandes	1	1	D	1	0	H
1499	SP2	201516	2016-02-20	Alcorcon	Ath Bilbao B	1	0	H	0	0	D
1500	SP2	201516	2016-02-20	Lugo	Leganes	1	2	A	1	1	D
1501	SP2	201516	2016-02-20	Mallorca	Gimnastic	2	2	D	0	2	A
1502	SP2	201516	2016-02-20	Ponferradina	Cordoba	1	3	A	0	2	A
1503	SP2	201516	2016-02-21	Alaves	Almeria	1	1	D	0	1	A
1504	SP2	201516	2016-02-21	Elche	Huesca	1	1	D	0	1	A
1505	SP2	201516	2016-02-21	Girona	Oviedo	1	1	D	0	0	D
1506	SP2	201516	2016-02-21	Osasuna	Zaragoza	1	1	D	0	1	A
1507	SP2	201516	2016-02-21	Tenerife	Llagostera	3	1	H	2	1	H
1508	SP2	201516	2016-02-21	Valladolid	Numancia	2	2	D	1	1	D
1509	SP2	201516	2016-02-27	Ath Bilbao B	Ponferradina	4	2	H	2	1	H
1510	SP2	201516	2016-02-27	Cordoba	Osasuna	0	1	A	0	0	D
1511	SP2	201516	2016-02-27	Llagostera	Girona	0	1	A	0	0	D
1512	SP2	201516	2016-02-27	Numancia	Alcorcon	1	1	D	1	0	H
1513	SP2	201516	2016-02-28	Almeria	Albacete	1	0	H	0	0	D
1514	SP2	201516	2016-02-28	Gimnastic	Valladolid	1	1	D	1	1	D
1515	SP2	201516	2016-02-28	Leganes	Alaves	2	0	H	1	0	H
1516	SP2	201516	2016-02-28	Mirandes	Tenerife	1	2	A	0	1	A
1517	SP2	201516	2016-02-28	Oviedo	Elche	3	0	H	0	0	D
1518	SP2	201516	2016-02-28	Zaragoza	Lugo	3	1	H	0	0	D
1519	SP2	201516	2016-03-05	Ath Bilbao B	Cordoba	1	2	A	0	1	A
1520	SP2	201516	2016-03-05	Elche	Llagostera	1	1	D	0	0	D
1521	SP2	201516	2016-03-05	Girona	Mirandes	2	0	H	0	0	D
1522	SP2	201516	2016-03-05	Lugo	Osasuna	2	0	H	0	0	D
1523	SP2	201516	2016-03-05	Mallorca	Oviedo	1	0	H	0	0	D
1524	SP2	201516	2016-03-06	Alaves	Zaragoza	0	0	D	0	0	D
1525	SP2	201516	2016-03-06	Albacete	Leganes	0	3	A	0	2	A
1526	SP2	201516	2016-03-06	Alcorcon	Gimnastic	1	1	D	0	0	D
1527	SP2	201516	2016-03-06	Ponferradina	Numancia	1	0	H	0	0	D
1528	SP2	201516	2016-03-06	Tenerife	Almeria	0	0	D	0	0	D
1529	SP2	201516	2016-03-06	Valladolid	Huesca	0	1	A	0	1	A
1530	SP2	201516	2016-03-12	Almeria	Girona	1	0	H	1	0	H
1531	SP2	201516	2016-03-12	Mirandes	Elche	1	2	A	1	0	H
1532	SP2	201516	2016-03-12	Numancia	Ath Bilbao B	3	2	H	1	1	D
1533	SP2	201516	2016-03-12	Oviedo	Valladolid	2	4	A	1	3	A
1534	SP2	201516	2016-03-12	Zaragoza	Albacete	1	0	H	0	0	D
1535	SP2	201516	2016-03-13	Cordoba	Lugo	1	2	A	0	2	A
1536	SP2	201516	2016-03-13	Gimnastic	Ponferradina	1	1	D	0	1	A
1537	SP2	201516	2016-03-13	Huesca	Alcorcon	1	0	H	1	0	H
1538	SP2	201516	2016-03-13	Leganes	Tenerife	0	1	A	0	0	D
1539	SP2	201516	2016-03-13	Llagostera	Mallorca	3	0	H	1	0	H
1540	SP2	201516	2016-03-13	Osasuna	Alaves	3	1	H	3	1	H
1541	SP2	201516	2016-03-16	Huesca	Mallorca	1	2	A	0	2	A
1542	SP2	201516	2016-03-19	Alaves	Lugo	0	0	D	0	0	D
1543	SP2	201516	2016-03-19	Albacete	Osasuna	3	1	H	2	1	H
1544	SP2	201516	2016-03-19	Alcorcon	Oviedo	1	0	H	0	0	D
1545	SP2	201516	2016-03-19	Elche	Almeria	0	0	D	0	0	D
1546	SP2	201516	2016-03-19	Valladolid	Llagostera	3	0	H	1	0	H
1547	SP2	201516	2016-03-20	Ath Bilbao B	Gimnastic	0	4	A	0	1	A
1548	SP2	201516	2016-03-20	Girona	Leganes	1	1	D	0	0	D
1549	SP2	201516	2016-03-20	Mallorca	Mirandes	1	1	D	1	1	D
1550	SP2	201516	2016-03-20	Numancia	Cordoba	1	1	D	1	1	D
1551	SP2	201516	2016-03-20	Ponferradina	Huesca	2	1	H	1	0	H
1552	SP2	201516	2016-03-20	Tenerife	Zaragoza	0	0	D	0	0	D
1553	SP2	201516	2016-03-26	Gimnastic	Numancia	1	0	H	0	0	D
1554	SP2	201516	2016-03-26	Huesca	Ath Bilbao B	1	2	A	0	0	D
1555	SP2	201516	2016-03-26	Leganes	Elche	0	0	D	0	0	D
1556	SP2	201516	2016-03-26	Osasuna	Tenerife	0	0	D	0	0	D
1557	SP2	201516	2016-03-26	Oviedo	Ponferradina	3	0	H	2	0	H
1558	SP2	201516	2016-03-27	Almeria	Mallorca	1	1	D	0	0	D
1559	SP2	201516	2016-03-27	Cordoba	Alaves	1	2	A	0	0	D
1560	SP2	201516	2016-03-27	Llagostera	Alcorcon	4	0	H	3	0	H
1561	SP2	201516	2016-03-27	Lugo	Albacete	2	1	H	1	0	H
1562	SP2	201516	2016-03-27	Mirandes	Valladolid	4	1	H	2	0	H
1563	SP2	201516	2016-03-27	Zaragoza	Girona	0	3	A	0	2	A
1564	SP2	201516	2016-04-02	Alcorcon	Mirandes	1	0	H	0	0	D
1565	SP2	201516	2016-04-02	Elche	Zaragoza	2	1	H	1	1	D
1566	SP2	201516	2016-04-02	Mallorca	Leganes	3	0	H	0	0	D
1567	SP2	201516	2016-04-02	Ponferradina	Llagostera	1	0	H	0	0	D
1568	SP2	201516	2016-04-03	Albacete	Alaves	0	1	A	0	0	D
1569	SP2	201516	2016-04-03	Gimnastic	Cordoba	4	4	D	2	3	A
1570	SP2	201516	2016-04-03	Girona	Osasuna	0	0	D	0	0	D
1571	SP2	201516	2016-04-03	Numancia	Huesca	3	2	H	1	1	D
1572	SP2	201516	2016-04-03	Tenerife	Lugo	1	0	H	0	0	D
1573	SP2	201516	2016-04-03	Valladolid	Almeria	1	1	D	0	0	D
1574	SP2	201516	2016-04-04	Ath Bilbao B	Oviedo	2	1	H	1	1	D
1575	SP2	201516	2016-04-09	Almeria	Alcorcon	1	1	D	1	1	D
1576	SP2	201516	2016-04-09	Leganes	Valladolid	4	0	H	2	0	H
1577	SP2	201516	2016-04-09	Llagostera	Ath Bilbao B	2	1	H	0	0	D
1578	SP2	201516	2016-04-09	Lugo	Girona	1	1	D	1	1	D
1579	SP2	201516	2016-04-09	Mirandes	Ponferradina	1	0	H	1	0	H
1580	SP2	201516	2016-04-10	Alaves	Tenerife	2	2	D	1	1	D
1581	SP2	201516	2016-04-10	Cordoba	Albacete	2	3	A	0	1	A
1582	SP2	201516	2016-04-10	Huesca	Gimnastic	2	0	H	1	0	H
1583	SP2	201516	2016-04-10	Osasuna	Elche	0	0	D	0	0	D
1584	SP2	201516	2016-04-10	Oviedo	Numancia	1	0	H	0	0	D
1585	SP2	201516	2016-04-10	Zaragoza	Mallorca	2	1	H	1	1	D
1586	SP2	201516	2016-04-16	Ath Bilbao B	Mirandes	1	1	D	0	0	D
1587	SP2	201516	2016-04-16	Elche	Lugo	2	0	H	1	0	H
1588	SP2	201516	2016-04-16	Girona	Alaves	1	0	H	1	0	H
1589	SP2	201516	2016-04-16	Numancia	Llagostera	1	1	D	0	0	D
1590	SP2	201516	2016-04-16	Valladolid	Zaragoza	1	2	A	1	1	D
1591	SP2	201516	2016-04-17	Alcorcon	Leganes	2	0	H	1	0	H
1592	SP2	201516	2016-04-17	Gimnastic	Oviedo	0	0	D	0	0	D
1593	SP2	201516	2016-04-17	Huesca	Cordoba	0	2	A	0	1	A
1594	SP2	201516	2016-04-17	Mallorca	Osasuna	1	1	D	1	0	H
1595	SP2	201516	2016-04-17	Ponferradina	Almeria	1	3	A	0	2	A
1596	SP2	201516	2016-04-17	Tenerife	Albacete	1	0	H	0	0	D
1597	SP2	201516	2016-04-23	Alaves	Elche	0	0	D	0	0	D
1598	SP2	201516	2016-04-23	Albacete	Girona	0	3	A	0	1	A
1599	SP2	201516	2016-04-23	Leganes	Ponferradina	3	0	H	1	0	H
1600	SP2	201516	2016-04-23	Llagostera	Gimnastic	1	1	D	0	0	D
1601	SP2	201516	2016-04-23	Oviedo	Huesca	0	1	A	0	0	D
1602	SP2	201516	2016-04-24	Almeria	Ath Bilbao B	3	2	H	1	1	D
1603	SP2	201516	2016-04-24	Cordoba	Tenerife	0	0	D	0	0	D
1604	SP2	201516	2016-04-24	Lugo	Mallorca	2	1	H	1	0	H
1605	SP2	201516	2016-04-24	Mirandes	Numancia	0	2	A	0	2	A
1606	SP2	201516	2016-04-24	Osasuna	Valladolid	1	0	H	1	0	H
1607	SP2	201516	2016-04-24	Zaragoza	Alcorcon	3	1	H	2	1	H
1608	SP2	201516	2016-04-30	Alcorcon	Osasuna	0	1	A	0	1	A
1609	SP2	201516	2016-04-30	Huesca	Llagostera	3	1	H	3	0	H
1610	SP2	201516	2016-04-30	Mallorca	Alaves	0	0	D	0	0	D
1611	SP2	201516	2016-04-30	Numancia	Almeria	2	0	H	1	0	H
1612	SP2	201516	2016-05-01	Elche	Albacete	1	1	D	0	0	D
1613	SP2	201516	2016-05-01	Gimnastic	Mirandes	3	2	H	0	1	A
1614	SP2	201516	2016-05-01	Girona	Tenerife	1	0	H	0	0	D
1615	SP2	201516	2016-05-01	Oviedo	Cordoba	1	0	H	1	0	H
1616	SP2	201516	2016-05-01	Ponferradina	Zaragoza	1	1	D	0	0	D
1617	SP2	201516	2016-05-01	Valladolid	Lugo	1	1	D	0	0	D
1618	SP2	201516	2016-05-02	Ath Bilbao B	Leganes	1	2	A	1	0	H
1619	SP2	201516	2016-05-07	Almeria	Gimnastic	1	2	A	1	1	D
1620	SP2	201516	2016-05-07	Llagostera	Oviedo	2	0	H	1	0	H
1621	SP2	201516	2016-05-07	Lugo	Alcorcon	1	2	A	1	1	D
1622	SP2	201516	2016-05-07	Osasuna	Ponferradina	0	0	D	0	0	D
1623	SP2	201516	2016-05-07	Tenerife	Elche	1	1	D	0	0	D
1624	SP2	201516	2016-05-08	Alaves	Valladolid	2	1	H	0	0	D
1625	SP2	201516	2016-05-08	Albacete	Mallorca	1	0	H	0	0	D
1626	SP2	201516	2016-05-08	Cordoba	Girona	1	0	H	0	0	D
1627	SP2	201516	2016-05-08	Leganes	Numancia	2	2	D	0	1	A
1628	SP2	201516	2016-05-08	Mirandes	Huesca	1	0	H	1	0	H
1629	SP2	201516	2016-05-08	Zaragoza	Ath Bilbao B	2	0	H	1	0	H
1630	SP2	201516	2016-05-14	Mallorca	Tenerife	1	0	H	0	0	D
1631	SP2	201516	2016-05-14	Numancia	Zaragoza	2	2	D	1	2	A
1632	SP2	201516	2016-05-14	Oviedo	Mirandes	4	1	H	1	0	H
1633	SP2	201516	2016-05-14	Valladolid	Albacete	1	0	H	1	0	H
1634	SP2	201516	2016-05-15	Alcorcon	Alaves	0	1	A	0	0	D
1635	SP2	201516	2016-05-15	Ath Bilbao B	Osasuna	0	0	D	0	0	D
1636	SP2	201516	2016-05-15	Elche	Girona	1	1	D	0	1	A
1637	SP2	201516	2016-05-15	Gimnastic	Leganes	0	0	D	0	0	D
1638	SP2	201516	2016-05-15	Huesca	Almeria	2	1	H	0	1	A
1639	SP2	201516	2016-05-15	Llagostera	Cordoba	1	0	H	1	0	H
1640	SP2	201516	2016-05-15	Ponferradina	Lugo	2	1	H	1	0	H
1641	SP2	201516	2016-05-21	Albacete	Alcorcon	0	2	A	0	0	D
1642	SP2	201516	2016-05-21	Cordoba	Elche	3	1	H	1	0	H
1643	SP2	201516	2016-05-21	Girona	Mallorca	1	0	H	0	0	D
1644	SP2	201516	2016-05-21	Leganes	Huesca	2	3	A	1	1	D
1645	SP2	201516	2016-05-21	Tenerife	Valladolid	3	1	H	2	0	H
1646	SP2	201516	2016-05-22	Alaves	Ponferradina	2	0	H	2	0	H
1647	SP2	201516	2016-05-22	Almeria	Oviedo	3	1	H	0	0	D
1648	SP2	201516	2016-05-22	Lugo	Ath Bilbao B	2	0	H	1	0	H
1649	SP2	201516	2016-05-22	Mirandes	Llagostera	0	0	D	0	0	D
1650	SP2	201516	2016-05-22	Osasuna	Numancia	3	2	H	1	2	A
1651	SP2	201516	2016-05-22	Zaragoza	Gimnastic	0	1	A	0	0	D
1652	SP2	201516	2016-05-24	Alcorcon	Tenerife	2	1	H	1	0	H
1653	SP2	201516	2016-05-24	Mallorca	Elche	2	1	H	1	0	H
1654	SP2	201516	2016-05-24	Valladolid	Girona	0	0	D	0	0	D
1655	SP2	201516	2016-05-25	Gimnastic	Osasuna	1	0	H	0	0	D
1656	SP2	201516	2016-05-25	Llagostera	Almeria	0	0	D	0	0	D
1657	SP2	201516	2016-05-25	Mirandes	Cordoba	0	3	A	0	0	D
1658	SP2	201516	2016-05-25	Numancia	Lugo	1	0	H	1	0	H
1659	SP2	201516	2016-05-25	Ponferradina	Albacete	2	1	H	0	0	D
1660	SP2	201516	2016-05-26	Ath Bilbao B	Alaves	2	3	A	0	2	A
1661	SP2	201516	2016-05-26	Huesca	Zaragoza	1	1	D	0	1	A
1662	SP2	201516	2016-05-26	Oviedo	Leganes	0	1	A	0	0	D
1663	SP2	201516	2016-05-29	Alaves	Numancia	2	0	H	2	0	H
1664	SP2	201516	2016-05-29	Albacete	Ath Bilbao B	2	1	H	0	0	D
1665	SP2	201516	2016-05-29	Almeria	Mirandes	2	1	H	1	0	H
1666	SP2	201516	2016-05-29	Elche	Valladolid	2	2	D	1	1	D
1667	SP2	201516	2016-05-29	Girona	Alcorcon	2	0	H	1	0	H
1668	SP2	201516	2016-05-29	Leganes	Llagostera	2	0	H	1	0	H
1669	SP2	201516	2016-05-29	Lugo	Gimnastic	0	3	A	0	2	A
1670	SP2	201516	2016-05-29	Mallorca	Cordoba	0	1	A	0	1	A
1671	SP2	201516	2016-05-29	Osasuna	Huesca	2	3	A	1	2	A
1672	SP2	201516	2016-05-29	Tenerife	Ponferradina	1	1	D	0	0	D
1673	SP2	201516	2016-05-29	Zaragoza	Oviedo	1	0	H	1	0	H
1674	SP2	201516	2016-06-04	Alcorcon 	Elche	4	1	H	2	0	H
1675	SP2	201516	2016-06-04	Ath Bilbao B 	Tenerife	2	0	H	1	0	H
1676	SP2	201516	2016-06-04	Cordoba 	Almeria	1	1	D	0	1	A
1677	SP2	201516	2016-06-04	Gimnastic 	Alaves	1	1	D	0	0	D
1678	SP2	201516	2016-06-04	Huesca 	Lugo	1	0	H	0	0	D
1679	SP2	201516	2016-06-04	Llagostera 	Zaragoza	6	2	H	2	0	H
1680	SP2	201516	2016-06-04	Mirandes 	Leganes	0	1	A	0	0	D
1681	SP2	201516	2016-06-04	Numancia 	Albacete	2	0	H	0	0	D
1682	SP2	201516	2016-06-04	Oviedo 	Osasuna	0	5	A	0	1	A
1683	SP2	201516	2016-06-04	Ponferradina 	Girona	0	1	A	0	0	D
1684	SP2	201516	2016-06-04	Valladolid 	Mallorca	1	3	A	1	2	A
1685	E0	201617	2016-08-13	Burnley	Swansea	0	1	A	0	0	D
1686	E0	201617	2016-08-13	Crystal Palace	West Brom	0	1	A	0	0	D
1687	E0	201617	2016-08-13	Everton	Tottenham	1	1	D	1	0	H
1688	E0	201617	2016-08-13	Hull	Leicester	2	1	H	1	0	H
1689	E0	201617	2016-08-13	Man City	Sunderland	2	1	H	1	0	H
1690	E0	201617	2016-08-13	Middlesbrough	Stoke	1	1	D	1	0	H
1691	E0	201617	2016-08-13	Southampton	Watford	1	1	D	0	1	A
1692	E0	201617	2016-08-14	Arsenal	Liverpool	3	4	A	1	1	D
1693	E0	201617	2016-08-14	Bournemouth	Man United	1	3	A	0	1	A
1694	E0	201617	2016-08-15	Chelsea	West Ham	2	1	H	0	0	D
1695	E0	201617	2016-08-19	Man United	Southampton	2	0	H	1	0	H
1696	E0	201617	2016-08-20	Burnley	Liverpool	2	0	H	2	0	H
1697	E0	201617	2016-08-20	Leicester	Arsenal	0	0	D	0	0	D
1698	E0	201617	2016-08-20	Stoke	Man City	1	4	A	0	2	A
1699	E0	201617	2016-08-20	Swansea	Hull	0	2	A	0	0	D
1700	E0	201617	2016-08-20	Tottenham	Crystal Palace	1	0	H	0	0	D
1701	E0	201617	2016-08-20	Watford	Chelsea	1	2	A	0	0	D
1702	E0	201617	2016-08-20	West Brom	Everton	1	2	A	1	1	D
1703	E0	201617	2016-08-21	Sunderland	Middlesbrough	1	2	A	0	2	A
1704	E0	201617	2016-08-21	West Ham	Bournemouth	1	0	H	0	0	D
1705	E0	201617	2016-08-27	Chelsea	Burnley	3	0	H	2	0	H
1706	E0	201617	2016-08-27	Crystal Palace	Bournemouth	1	1	D	0	1	A
1707	E0	201617	2016-08-27	Everton	Stoke	1	0	H	0	0	D
1708	E0	201617	2016-08-27	Hull	Man United	0	1	A	0	0	D
1709	E0	201617	2016-08-27	Leicester	Swansea	2	1	H	1	0	H
1710	E0	201617	2016-08-27	Southampton	Sunderland	1	1	D	0	0	D
1711	E0	201617	2016-08-27	Tottenham	Liverpool	1	1	D	0	1	A
1712	E0	201617	2016-08-27	Watford	Arsenal	1	3	A	0	3	A
1713	E0	201617	2016-08-28	Man City	West Ham	3	1	H	2	0	H
1714	E0	201617	2016-08-28	West Brom	Middlesbrough	0	0	D	0	0	D
1715	E0	201617	2016-09-10	Arsenal	Southampton	2	1	H	1	1	D
1716	E0	201617	2016-09-10	Bournemouth	West Brom	1	0	H	0	0	D
1717	E0	201617	2016-09-10	Burnley	Hull	1	1	D	0	0	D
1718	E0	201617	2016-09-10	Liverpool	Leicester	4	1	H	2	1	H
1719	E0	201617	2016-09-10	Man United	Man City	1	2	A	1	2	A
1720	E0	201617	2016-09-10	Middlesbrough	Crystal Palace	1	2	A	1	1	D
1721	E0	201617	2016-09-10	Stoke	Tottenham	0	4	A	0	1	A
1722	E0	201617	2016-09-10	West Ham	Watford	2	4	A	2	2	D
1723	E0	201617	2016-09-11	Swansea	Chelsea	2	2	D	0	1	A
1724	E0	201617	2016-09-12	Sunderland	Everton	0	3	A	0	0	D
1725	E0	201617	2016-09-16	Chelsea	Liverpool	1	2	A	0	2	A
1726	E0	201617	2016-09-17	Everton	Middlesbrough	3	1	H	3	1	H
1727	E0	201617	2016-09-17	Hull	Arsenal	1	4	A	0	1	A
1728	E0	201617	2016-09-17	Leicester	Burnley	3	0	H	1	0	H
1729	E0	201617	2016-09-17	Man City	Bournemouth	4	0	H	2	0	H
1730	E0	201617	2016-09-17	West Brom	West Ham	4	2	H	3	0	H
1731	E0	201617	2016-09-18	Crystal Palace	Stoke	4	1	H	2	0	H
1732	E0	201617	2016-09-18	Southampton	Swansea	1	0	H	0	0	D
1733	E0	201617	2016-09-18	Tottenham	Sunderland	1	0	H	0	0	D
1734	E0	201617	2016-09-18	Watford	Man United	3	1	H	1	0	H
1735	E0	201617	2016-09-24	Arsenal	Chelsea	3	0	H	3	0	H
1736	E0	201617	2016-09-24	Bournemouth	Everton	1	0	H	1	0	H
1737	E0	201617	2016-09-24	Liverpool	Hull	5	1	H	3	0	H
1738	E0	201617	2016-09-24	Man United	Leicester	4	1	H	4	0	H
1739	E0	201617	2016-09-24	Middlesbrough	Tottenham	1	2	A	0	2	A
1740	E0	201617	2016-09-24	Stoke	West Brom	1	1	D	0	0	D
1741	E0	201617	2016-09-24	Sunderland	Crystal Palace	2	3	A	1	0	H
1742	E0	201617	2016-09-24	Swansea	Man City	1	3	A	1	1	D
1743	E0	201617	2016-09-25	West Ham	Southampton	0	3	A	0	1	A
1744	E0	201617	2016-09-26	Burnley	Watford	2	0	H	1	0	H
1745	E0	201617	2016-09-30	Everton	Crystal Palace	1	1	D	1	0	H
1746	E0	201617	2016-10-01	Hull	Chelsea	0	2	A	0	0	D
1747	E0	201617	2016-10-01	Sunderland	West Brom	1	1	D	0	1	A
1748	E0	201617	2016-10-01	Swansea	Liverpool	1	2	A	1	0	H
1749	E0	201617	2016-10-01	Watford	Bournemouth	2	2	D	0	1	A
1750	E0	201617	2016-10-01	West Ham	Middlesbrough	1	1	D	0	0	D
1751	E0	201617	2016-10-02	Burnley	Arsenal	0	1	A	0	0	D
1752	E0	201617	2016-10-02	Leicester	Southampton	0	0	D	0	0	D
1753	E0	201617	2016-10-02	Man United	Stoke	1	1	D	0	0	D
1754	E0	201617	2016-10-02	Tottenham	Man City	2	0	H	2	0	H
1755	E0	201617	2016-10-15	Arsenal	Swansea	3	2	H	2	1	H
1756	E0	201617	2016-10-15	Bournemouth	Hull	6	1	H	3	1	H
1757	E0	201617	2016-10-15	Chelsea	Leicester	3	0	H	2	0	H
1758	E0	201617	2016-10-15	Crystal Palace	West Ham	0	1	A	0	1	A
1759	E0	201617	2016-10-15	Man City	Everton	1	1	D	0	0	D
1760	E0	201617	2016-10-15	Stoke	Sunderland	2	0	H	2	0	H
1761	E0	201617	2016-10-15	West Brom	Tottenham	1	1	D	0	0	D
1762	E0	201617	2016-10-16	Middlesbrough	Watford	0	1	A	0	0	D
1763	E0	201617	2016-10-16	Southampton	Burnley	3	1	H	0	0	D
1764	E0	201617	2016-10-17	Liverpool	Man United	0	0	D	0	0	D
1765	E0	201617	2016-10-22	Arsenal	Middlesbrough	0	0	D	0	0	D
1766	E0	201617	2016-10-22	Bournemouth	Tottenham	0	0	D	0	0	D
1767	E0	201617	2016-10-22	Burnley	Everton	2	1	H	1	0	H
1768	E0	201617	2016-10-22	Hull	Stoke	0	2	A	0	1	A
1769	E0	201617	2016-10-22	Leicester	Crystal Palace	3	1	H	1	0	H
1770	E0	201617	2016-10-22	Liverpool	West Brom	2	1	H	2	0	H
1771	E0	201617	2016-10-22	Swansea	Watford	0	0	D	0	0	D
1772	E0	201617	2016-10-22	West Ham	Sunderland	1	0	H	0	0	D
1773	E0	201617	2016-10-23	Chelsea	Man United	4	0	H	2	0	H
1774	E0	201617	2016-10-23	Man City	Southampton	1	1	D	0	1	A
1775	E0	201617	2016-10-29	Crystal Palace	Liverpool	2	4	A	2	3	A
1776	E0	201617	2016-10-29	Man United	Burnley	0	0	D	0	0	D
1777	E0	201617	2016-10-29	Middlesbrough	Bournemouth	2	0	H	1	0	H
1778	E0	201617	2016-10-29	Sunderland	Arsenal	1	4	A	0	1	A
1779	E0	201617	2016-10-29	Tottenham	Leicester	1	1	D	1	0	H
1780	E0	201617	2016-10-29	Watford	Hull	1	0	H	0	0	D
1781	E0	201617	2016-10-29	West Brom	Man City	0	4	A	0	2	A
1782	E0	201617	2016-10-30	Everton	West Ham	2	0	H	0	0	D
1783	E0	201617	2016-10-30	Southampton	Chelsea	0	2	A	0	1	A
1784	E0	201617	2016-10-31	Stoke	Swansea	3	1	H	1	1	D
1785	E0	201617	2016-11-05	Bournemouth	Sunderland	1	2	A	1	1	D
1786	E0	201617	2016-11-05	Burnley	Crystal Palace	3	2	H	2	0	H
1787	E0	201617	2016-11-05	Chelsea	Everton	5	0	H	3	0	H
1788	E0	201617	2016-11-05	Man City	Middlesbrough	1	1	D	1	0	H
1789	E0	201617	2016-11-05	West Ham	Stoke	1	1	D	0	0	D
1790	E0	201617	2016-11-06	Arsenal	Tottenham	1	1	D	1	0	H
1791	E0	201617	2016-11-06	Hull	Southampton	2	1	H	0	1	A
1792	E0	201617	2016-11-06	Leicester	West Brom	1	2	A	0	0	D
1793	E0	201617	2016-11-06	Liverpool	Watford	6	1	H	3	0	H
1794	E0	201617	2016-11-06	Swansea	Man United	1	3	A	0	3	A
1795	E0	201617	2016-11-19	Crystal Palace	Man City	1	2	A	0	1	A
1796	E0	201617	2016-11-19	Everton	Swansea	1	1	D	0	1	A
1797	E0	201617	2016-11-19	Man United	Arsenal	1	1	D	0	0	D
1798	E0	201617	2016-11-19	Southampton	Liverpool	0	0	D	0	0	D
1799	E0	201617	2016-11-19	Stoke	Bournemouth	0	1	A	0	1	A
1800	E0	201617	2016-11-19	Sunderland	Hull	3	0	H	1	0	H
1801	E0	201617	2016-11-19	Tottenham	West Ham	3	2	H	0	1	A
1802	E0	201617	2016-11-19	Watford	Leicester	2	1	H	2	1	H
1803	E0	201617	2016-11-20	Middlesbrough	Chelsea	0	1	A	0	1	A
1804	E0	201617	2016-11-21	West Brom	Burnley	4	0	H	3	0	H
1805	E0	201617	2016-11-26	Burnley	Man City	1	2	A	1	1	D
1806	E0	201617	2016-11-26	Chelsea	Tottenham	2	1	H	1	1	D
1807	E0	201617	2016-11-26	Hull	West Brom	1	1	D	0	1	A
1808	E0	201617	2016-11-26	Leicester	Middlesbrough	2	2	D	1	1	D
1809	E0	201617	2016-11-26	Liverpool	Sunderland	2	0	H	0	0	D
1810	E0	201617	2016-11-26	Swansea	Crystal Palace	5	4	H	1	1	D
1811	E0	201617	2016-11-27	Arsenal	Bournemouth	3	1	H	1	1	D
1812	E0	201617	2016-11-27	Man United	West Ham	1	1	D	1	1	D
1813	E0	201617	2016-11-27	Southampton	Everton	1	0	H	1	0	H
1814	E0	201617	2016-11-27	Watford	Stoke	0	1	A	0	1	A
1815	E0	201617	2016-12-03	Crystal Palace	Southampton	3	0	H	2	0	H
1816	E0	201617	2016-12-03	Man City	Chelsea	1	3	A	1	0	H
1817	E0	201617	2016-12-03	Stoke	Burnley	2	0	H	2	0	H
1818	E0	201617	2016-12-03	Sunderland	Leicester	2	1	H	0	0	D
1819	E0	201617	2016-12-03	Tottenham	Swansea	5	0	H	2	0	H
1820	E0	201617	2016-12-03	West Brom	Watford	3	1	H	2	0	H
1821	E0	201617	2016-12-03	West Ham	Arsenal	1	5	A	0	1	A
1822	E0	201617	2016-12-04	Bournemouth	Liverpool	4	3	H	0	2	A
1823	E0	201617	2016-12-04	Everton	Man United	1	1	D	0	1	A
1824	E0	201617	2016-12-05	Middlesbrough	Hull	1	0	H	0	0	D
1825	E0	201617	2016-12-10	Arsenal	Stoke	3	1	H	1	1	D
1826	E0	201617	2016-12-10	Burnley	Bournemouth	3	2	H	2	1	H
1827	E0	201617	2016-12-10	Hull	Crystal Palace	3	3	D	1	0	H
1828	E0	201617	2016-12-10	Leicester	Man City	4	2	H	3	0	H
1829	E0	201617	2016-12-10	Swansea	Sunderland	3	0	H	0	0	D
1830	E0	201617	2016-12-10	Watford	Everton	3	2	H	1	1	D
1831	E0	201617	2016-12-11	Chelsea	West Brom	1	0	H	0	0	D
1832	E0	201617	2016-12-11	Liverpool	West Ham	2	2	D	1	2	A
1833	E0	201617	2016-12-11	Man United	Tottenham	1	0	H	1	0	H
1834	E0	201617	2016-12-11	Southampton	Middlesbrough	1	0	H	0	0	D
1835	E0	201617	2016-12-13	Bournemouth	Leicester	1	0	H	1	0	H
1836	E0	201617	2016-12-13	Everton	Arsenal	2	1	H	1	1	D
1837	E0	201617	2016-12-14	Crystal Palace	Man United	1	2	A	0	1	A
1838	E0	201617	2016-12-14	Man City	Watford	2	0	H	1	0	H
1839	E0	201617	2016-12-14	Middlesbrough	Liverpool	0	3	A	0	1	A
1840	E0	201617	2016-12-14	Stoke	Southampton	0	0	D	0	0	D
1841	E0	201617	2016-12-14	Sunderland	Chelsea	0	1	A	0	1	A
1842	E0	201617	2016-12-14	Tottenham	Hull	3	0	H	1	0	H
1843	E0	201617	2016-12-14	West Brom	Swansea	3	1	H	0	0	D
1844	E0	201617	2016-12-14	West Ham	Burnley	1	0	H	1	0	H
1845	E0	201617	2016-12-17	Crystal Palace	Chelsea	0	1	A	0	1	A
1846	E0	201617	2016-12-17	Middlesbrough	Swansea	3	0	H	2	0	H
1847	E0	201617	2016-12-17	Stoke	Leicester	2	2	D	2	0	H
1848	E0	201617	2016-12-17	Sunderland	Watford	1	0	H	0	0	D
1849	E0	201617	2016-12-17	West Brom	Man United	0	2	A	0	1	A
1850	E0	201617	2016-12-17	West Ham	Hull	1	0	H	0	0	D
1851	E0	201617	2016-12-18	Bournemouth	Southampton	1	3	A	1	1	D
1852	E0	201617	2016-12-18	Man City	Arsenal	2	1	H	0	1	A
1853	E0	201617	2016-12-18	Tottenham	Burnley	2	1	H	1	1	D
1854	E0	201617	2016-12-19	Everton	Liverpool	0	1	A	0	0	D
1855	E0	201617	2016-12-26	Arsenal	West Brom	1	0	H	0	0	D
1856	E0	201617	2016-12-26	Burnley	Middlesbrough	1	0	H	0	0	D
1857	E0	201617	2016-12-26	Chelsea	Bournemouth	3	0	H	1	0	H
1858	E0	201617	2016-12-26	Hull	Man City	0	3	A	0	0	D
1859	E0	201617	2016-12-26	Leicester	Everton	0	2	A	0	0	D
1860	E0	201617	2016-12-26	Man United	Sunderland	3	1	H	1	0	H
1861	E0	201617	2016-12-26	Swansea	West Ham	1	4	A	0	1	A
1862	E0	201617	2016-12-26	Watford	Crystal Palace	1	1	D	0	1	A
1863	E0	201617	2016-12-27	Liverpool	Stoke	4	1	H	2	1	H
1864	E0	201617	2016-12-28	Southampton	Tottenham	1	4	A	1	1	D
1865	E0	201617	2016-12-30	Hull	Everton	2	2	D	1	1	D
1866	E0	201617	2016-12-31	Burnley	Sunderland	4	1	H	1	0	H
1867	E0	201617	2016-12-31	Chelsea	Stoke	4	2	H	1	0	H
1868	E0	201617	2016-12-31	Leicester	West Ham	1	0	H	1	0	H
1869	E0	201617	2016-12-31	Liverpool	Man City	1	0	H	1	0	H
1870	E0	201617	2016-12-31	Man United	Middlesbrough	2	1	H	0	0	D
1871	E0	201617	2016-12-31	Southampton	West Brom	1	2	A	1	1	D
1872	E0	201617	2016-12-31	Swansea	Bournemouth	0	3	A	0	2	A
1873	E0	201617	2017-01-01	Arsenal	Crystal Palace	2	0	H	1	0	H
1874	E0	201617	2017-01-01	Watford	Tottenham	1	4	A	0	3	A
1875	E0	201617	2017-01-02	Everton	Southampton	3	0	H	0	0	D
1876	E0	201617	2017-01-02	Man City	Burnley	2	1	H	0	0	D
1877	E0	201617	2017-01-02	Middlesbrough	Leicester	0	0	D	0	0	D
1878	E0	201617	2017-01-02	Sunderland	Liverpool	2	2	D	1	1	D
1879	E0	201617	2017-01-02	West Brom	Hull	3	1	H	0	1	A
1880	E0	201617	2017-01-02	West Ham	Man United	0	2	A	0	0	D
1881	E0	201617	2017-01-03	Bournemouth	Arsenal	3	3	D	2	0	H
1882	E0	201617	2017-01-03	Crystal Palace	Swansea	1	2	A	0	1	A
1883	E0	201617	2017-01-03	Stoke	Watford	2	0	H	1	0	H
1884	E0	201617	2017-01-04	Tottenham	Chelsea	2	0	H	1	0	H
1885	E0	201617	2017-01-14	Burnley	Southampton	1	0	H	0	0	D
1886	E0	201617	2017-01-14	Hull	Bournemouth	3	1	H	1	1	D
1887	E0	201617	2017-01-14	Leicester	Chelsea	0	3	A	0	1	A
1888	E0	201617	2017-01-14	Sunderland	Stoke	1	3	A	1	3	A
1889	E0	201617	2017-01-14	Swansea	Arsenal	0	4	A	0	1	A
1890	E0	201617	2017-01-14	Tottenham	West Brom	4	0	H	2	0	H
1891	E0	201617	2017-01-14	Watford	Middlesbrough	0	0	D	0	0	D
1892	E0	201617	2017-01-14	West Ham	Crystal Palace	3	0	H	0	0	D
1893	E0	201617	2017-01-15	Everton	Man City	4	0	H	1	0	H
1894	E0	201617	2017-01-15	Man United	Liverpool	1	1	D	0	1	A
1895	E0	201617	2017-01-21	Bournemouth	Watford	2	2	D	0	1	A
1896	E0	201617	2017-01-21	Crystal Palace	Everton	0	1	A	0	0	D
1897	E0	201617	2017-01-21	Liverpool	Swansea	2	3	A	0	0	D
1898	E0	201617	2017-01-21	Man City	Tottenham	2	2	D	0	0	D
1899	E0	201617	2017-01-21	Middlesbrough	West Ham	1	3	A	1	2	A
1900	E0	201617	2017-01-21	Stoke	Man United	1	1	D	1	0	H
1901	E0	201617	2017-01-21	West Brom	Sunderland	2	0	H	2	0	H
1902	E0	201617	2017-01-22	Arsenal	Burnley	2	1	H	0	0	D
1903	E0	201617	2017-01-22	Chelsea	Hull	2	0	H	1	0	H
1904	E0	201617	2017-01-22	Southampton	Leicester	3	0	H	2	0	H
1905	E0	201617	2017-01-31	Arsenal	Watford	1	2	A	0	2	A
1906	E0	201617	2017-01-31	Bournemouth	Crystal Palace	0	2	A	0	0	D
1907	E0	201617	2017-01-31	Burnley	Leicester	1	0	H	0	0	D
1908	E0	201617	2017-01-31	Liverpool	Chelsea	1	1	D	0	1	A
1909	E0	201617	2017-01-31	Middlesbrough	West Brom	1	1	D	1	1	D
1910	E0	201617	2017-01-31	Sunderland	Tottenham	0	0	D	0	0	D
1911	E0	201617	2017-01-31	Swansea	Southampton	2	1	H	1	0	H
1912	E0	201617	2017-02-01	Man United	Hull	0	0	D	0	0	D
1913	E0	201617	2017-02-01	Stoke	Everton	1	1	D	1	1	D
1914	E0	201617	2017-02-01	West Ham	Man City	0	4	A	0	3	A
1915	E0	201617	2017-02-04	Chelsea	Arsenal	3	1	H	1	0	H
1916	E0	201617	2017-02-04	Crystal Palace	Sunderland	0	4	A	0	4	A
1917	E0	201617	2017-02-04	Everton	Bournemouth	6	3	H	3	0	H
1918	E0	201617	2017-02-04	Hull	Liverpool	2	0	H	1	0	H
1919	E0	201617	2017-02-04	Southampton	West Ham	1	3	A	1	2	A
1920	E0	201617	2017-02-04	Tottenham	Middlesbrough	1	0	H	0	0	D
1921	E0	201617	2017-02-04	Watford	Burnley	2	1	H	2	0	H
1922	E0	201617	2017-02-04	West Brom	Stoke	1	0	H	1	0	H
1923	E0	201617	2017-02-05	Leicester	Man United	0	3	A	0	2	A
1924	E0	201617	2017-02-05	Man City	Swansea	2	1	H	1	0	H
1925	E0	201617	2017-02-11	Arsenal	Hull	2	0	H	1	0	H
1926	E0	201617	2017-02-11	Liverpool	Tottenham	2	0	H	2	0	H
1927	E0	201617	2017-02-11	Man United	Watford	2	0	H	1	0	H
1928	E0	201617	2017-02-11	Middlesbrough	Everton	0	0	D	0	0	D
1929	E0	201617	2017-02-11	Stoke	Crystal Palace	1	0	H	0	0	D
1930	E0	201617	2017-02-11	Sunderland	Southampton	0	4	A	0	2	A
1931	E0	201617	2017-02-11	West Ham	West Brom	2	2	D	0	1	A
1932	E0	201617	2017-02-12	Burnley	Chelsea	1	1	D	1	1	D
1933	E0	201617	2017-02-12	Swansea	Leicester	2	0	H	2	0	H
1934	E0	201617	2017-02-13	Bournemouth	Man City	0	2	A	0	1	A
1935	E0	201617	2017-02-25	Chelsea	Swansea	3	1	H	1	1	D
1936	E0	201617	2017-02-25	Crystal Palace	Middlesbrough	1	0	H	1	0	H
1937	E0	201617	2017-02-25	Everton	Sunderland	2	0	H	1	0	H
1938	E0	201617	2017-02-25	Hull	Burnley	1	1	D	0	0	D
1939	E0	201617	2017-02-25	Watford	West Ham	1	1	D	1	0	H
1940	E0	201617	2017-02-25	West Brom	Bournemouth	2	1	H	2	1	H
1941	E0	201617	2017-02-26	Tottenham	Stoke	4	0	H	4	0	H
1942	E0	201617	2017-02-27	Leicester	Liverpool	3	1	H	2	0	H
1943	E0	201617	2017-03-04	Leicester	Hull	3	1	H	1	1	D
1944	E0	201617	2017-03-04	Liverpool	Arsenal	3	1	H	2	0	H
1945	E0	201617	2017-03-04	Man United	Bournemouth	1	1	D	1	1	D
1946	E0	201617	2017-03-04	Stoke	Middlesbrough	2	0	H	2	0	H
1947	E0	201617	2017-03-04	Swansea	Burnley	3	2	H	1	1	D
1948	E0	201617	2017-03-04	Watford	Southampton	3	4	A	1	2	A
1949	E0	201617	2017-03-04	West Brom	Crystal Palace	0	2	A	0	0	D
1950	E0	201617	2017-03-05	Sunderland	Man City	0	2	A	0	1	A
1951	E0	201617	2017-03-05	Tottenham	Everton	3	2	H	1	0	H
1952	E0	201617	2017-03-06	West Ham	Chelsea	1	2	A	0	1	A
1953	E0	201617	2017-03-08	Man City	Stoke	0	0	D	0	0	D
1954	E0	201617	2017-03-11	Bournemouth	West Ham	3	2	H	1	1	D
1955	E0	201617	2017-03-11	Everton	West Brom	3	0	H	2	0	H
1956	E0	201617	2017-03-11	Hull	Swansea	2	1	H	0	0	D
1957	E0	201617	2017-03-12	Liverpool	Burnley	2	1	H	1	1	D
1958	E0	201617	2017-03-18	Bournemouth	Swansea	2	0	H	1	0	H
1959	E0	201617	2017-03-18	Crystal Palace	Watford	1	0	H	0	0	D
1960	E0	201617	2017-03-18	Everton	Hull	4	0	H	1	0	H
1961	E0	201617	2017-03-18	Stoke	Chelsea	1	2	A	1	1	D
1962	E0	201617	2017-03-18	Sunderland	Burnley	0	0	D	0	0	D
1963	E0	201617	2017-03-18	West Brom	Arsenal	3	1	H	1	1	D
1964	E0	201617	2017-03-18	West Ham	Leicester	2	3	A	1	3	A
1965	E0	201617	2017-03-19	Man City	Liverpool	1	1	D	0	0	D
1966	E0	201617	2017-03-19	Middlesbrough	Man United	1	3	A	0	1	A
1967	E0	201617	2017-03-19	Tottenham	Southampton	2	1	H	2	0	H
1968	E0	201617	2017-04-01	Burnley	Tottenham	0	2	A	0	0	D
1969	E0	201617	2017-04-01	Chelsea	Crystal Palace	1	2	A	1	2	A
1970	E0	201617	2017-04-01	Hull	West Ham	2	1	H	0	1	A
1971	E0	201617	2017-04-01	Leicester	Stoke	2	0	H	1	0	H
1972	E0	201617	2017-04-01	Liverpool	Everton	3	1	H	2	1	H
1973	E0	201617	2017-04-01	Man United	West Brom	0	0	D	0	0	D
1974	E0	201617	2017-04-01	Southampton	Bournemouth	0	0	D	0	0	D
1975	E0	201617	2017-04-01	Watford	Sunderland	1	0	H	0	0	D
1976	E0	201617	2017-04-02	Arsenal	Man City	2	2	D	1	2	A
1977	E0	201617	2017-04-02	Swansea	Middlesbrough	0	0	D	0	0	D
1978	E0	201617	2017-04-04	Burnley	Stoke	1	0	H	0	0	D
1979	E0	201617	2017-04-04	Leicester	Sunderland	2	0	H	0	0	D
1980	E0	201617	2017-04-04	Man United	Everton	1	1	D	0	1	A
1981	E0	201617	2017-04-04	Watford	West Brom	2	0	H	1	0	H
1982	E0	201617	2017-04-05	Arsenal	West Ham	3	0	H	0	0	D
1983	E0	201617	2017-04-05	Chelsea	Man City	2	1	H	2	1	H
1984	E0	201617	2017-04-05	Hull	Middlesbrough	4	2	H	3	2	H
1985	E0	201617	2017-04-05	Liverpool	Bournemouth	2	2	D	1	1	D
1986	E0	201617	2017-04-05	Southampton	Crystal Palace	3	1	H	1	1	D
1987	E0	201617	2017-04-05	Swansea	Tottenham	1	3	A	1	0	H
1988	E0	201617	2017-04-08	Bournemouth	Chelsea	1	3	A	1	2	A
1989	E0	201617	2017-04-08	Man City	Hull	3	1	H	1	0	H
1990	E0	201617	2017-04-08	Middlesbrough	Burnley	0	0	D	0	0	D
1991	E0	201617	2017-04-08	Stoke	Liverpool	1	2	A	1	0	H
1992	E0	201617	2017-04-08	Tottenham	Watford	4	0	H	3	0	H
1993	E0	201617	2017-04-08	West Brom	Southampton	0	1	A	0	1	A
1994	E0	201617	2017-04-08	West Ham	Swansea	1	0	H	1	0	H
1995	E0	201617	2017-04-09	Everton	Leicester	4	2	H	3	2	H
1996	E0	201617	2017-04-09	Sunderland	Man United	0	3	A	0	1	A
1997	E0	201617	2017-04-10	Crystal Palace	Arsenal	3	0	H	1	0	H
1998	E0	201617	2017-04-15	Crystal Palace	Leicester	2	2	D	0	1	A
1999	E0	201617	2017-04-15	Everton	Burnley	3	1	H	0	0	D
2000	E0	201617	2017-04-15	Southampton	Man City	0	3	A	0	0	D
2001	E0	201617	2017-04-15	Stoke	Hull	3	1	H	1	0	H
2002	E0	201617	2017-04-15	Sunderland	West Ham	2	2	D	1	1	D
2003	E0	201617	2017-04-15	Tottenham	Bournemouth	4	0	H	2	0	H
2004	E0	201617	2017-04-15	Watford	Swansea	1	0	H	1	0	H
2005	E0	201617	2017-04-16	Man United	Chelsea	2	0	H	1	0	H
2006	E0	201617	2017-04-16	West Brom	Liverpool	0	1	A	0	1	A
2007	E0	201617	2017-04-17	Middlesbrough	Arsenal	1	2	A	0	1	A
2008	E0	201617	2017-04-22	Bournemouth	Middlesbrough	4	0	H	2	0	H
2009	E0	201617	2017-04-22	Hull	Watford	2	0	H	0	0	D
2010	E0	201617	2017-04-22	Swansea	Stoke	2	0	H	1	0	H
2011	E0	201617	2017-04-22	West Ham	Everton	0	0	D	0	0	D
2012	E0	201617	2017-04-23	Burnley	Man United	0	2	A	0	2	A
2013	E0	201617	2017-04-23	Liverpool	Crystal Palace	1	2	A	1	1	D
2014	E0	201617	2017-04-25	Chelsea	Southampton	4	2	H	2	1	H
2015	E0	201617	2017-04-26	Arsenal	Leicester	1	0	H	0	0	D
2016	E0	201617	2017-04-26	Crystal Palace	Tottenham	0	1	A	0	0	D
2017	E0	201617	2017-04-26	Middlesbrough	Sunderland	1	0	H	1	0	H
2018	E0	201617	2017-04-27	Man City	Man United	0	0	D	0	0	D
2019	E0	201617	2017-04-29	Crystal Palace	Burnley	0	2	A	0	1	A
2020	E0	201617	2017-04-29	Southampton	Hull	0	0	D	0	0	D
2021	E0	201617	2017-04-29	Stoke	West Ham	0	0	D	0	0	D
2022	E0	201617	2017-04-29	Sunderland	Bournemouth	0	1	A	0	0	D
2023	E0	201617	2017-04-29	West Brom	Leicester	0	1	A	0	1	A
2024	E0	201617	2017-04-30	Everton	Chelsea	0	3	A	0	0	D
2025	E0	201617	2017-04-30	Man United	Swansea	1	1	D	1	0	H
2026	E0	201617	2017-04-30	Middlesbrough	Man City	2	2	D	1	0	H
2027	E0	201617	2017-04-30	Tottenham	Arsenal	2	0	H	0	0	D
2028	E0	201617	2017-05-01	Watford	Liverpool	0	1	A	0	1	A
2029	E0	201617	2017-05-05	West Ham	Tottenham	1	0	H	0	0	D
2030	E0	201617	2017-05-06	Bournemouth	Stoke	2	2	D	0	1	A
2031	E0	201617	2017-05-06	Burnley	West Brom	2	2	D	0	0	D
2032	E0	201617	2017-05-06	Hull	Sunderland	0	2	A	0	0	D
2033	E0	201617	2017-05-06	Leicester	Watford	3	0	H	1	0	H
2034	E0	201617	2017-05-06	Man City	Crystal Palace	5	0	H	1	0	H
2035	E0	201617	2017-05-06	Swansea	Everton	1	0	H	1	0	H
2036	E0	201617	2017-05-07	Arsenal	Man United	2	0	H	0	0	D
2037	E0	201617	2017-05-07	Liverpool	Southampton	0	0	D	0	0	D
2038	E0	201617	2017-05-08	Chelsea	Middlesbrough	3	0	H	2	0	H
2039	E0	201617	2017-05-10	Southampton	Arsenal	0	2	A	0	0	D
2040	E0	201617	2017-05-12	Everton	Watford	1	0	H	0	0	D
2041	E0	201617	2017-05-12	West Brom	Chelsea	0	1	A	0	0	D
2042	E0	201617	2017-05-13	Bournemouth	Burnley	2	1	H	1	0	H
2043	E0	201617	2017-05-13	Man City	Leicester	2	1	H	2	1	H
2044	E0	201617	2017-05-13	Middlesbrough	Southampton	1	2	A	0	1	A
2045	E0	201617	2017-05-13	Stoke	Arsenal	1	4	A	0	1	A
2046	E0	201617	2017-05-13	Sunderland	Swansea	0	2	A	0	2	A
2047	E0	201617	2017-05-14	Crystal Palace	Hull	4	0	H	2	0	H
2048	E0	201617	2017-05-14	Tottenham	Man United	2	1	H	1	0	H
2049	E0	201617	2017-05-14	West Ham	Liverpool	0	4	A	0	1	A
2050	E0	201617	2017-05-15	Chelsea	Watford	4	3	H	2	1	H
2051	E0	201617	2017-05-16	Arsenal	Sunderland	2	0	H	0	0	D
2052	E0	201617	2017-05-16	Man City	West Brom	3	1	H	2	0	H
2053	E0	201617	2017-05-17	Southampton	Man United	0	0	D	0	0	D
2054	E0	201617	2017-05-18	Leicester	Tottenham	1	6	A	0	2	A
2055	E0	201617	2017-05-21	Arsenal	Everton	3	1	H	2	0	H
2056	E0	201617	2017-05-21	Burnley	West Ham	1	2	A	1	1	D
2057	E0	201617	2017-05-21	Chelsea	Sunderland	5	1	H	1	1	D
2058	E0	201617	2017-05-21	Hull	Tottenham	1	7	A	0	3	A
2059	E0	201617	2017-05-21	Leicester	Bournemouth	1	1	D	0	1	A
2060	E0	201617	2017-05-21	Liverpool	Middlesbrough	3	0	H	1	0	H
2061	E0	201617	2017-05-21	Man United	Crystal Palace	2	0	H	2	0	H
2062	E0	201617	2017-05-21	Southampton	Stoke	0	1	A	0	0	D
2063	E0	201617	2017-05-21	Swansea	West Brom	2	1	H	0	1	A
2064	E0	201617	2017-05-21	Watford	Man City	0	5	A	0	4	A
2065	D1	201617	2016-08-26	Bayern Munich	Werder Bremen	6	0	H	2	0	H
2066	D1	201617	2016-08-27	Augsburg	Wolfsburg	0	2	A	0	1	A
2067	D1	201617	2016-08-27	Dortmund	Mainz	2	1	H	1	0	H
2068	D1	201617	2016-08-27	Ein Frankfurt	Schalke 04	1	0	H	1	0	H
2069	D1	201617	2016-08-27	FC Koln	Darmstadt	2	0	H	1	0	H
2070	D1	201617	2016-08-27	Hamburg	Ingolstadt	1	1	D	1	0	H
2071	D1	201617	2016-08-27	M'gladbach	Leverkusen	2	1	H	1	0	H
2072	D1	201617	2016-08-28	Hertha	Freiburg	2	1	H	0	0	D
2073	D1	201617	2016-08-28	Hoffenheim	RB Leipzig	2	2	D	0	0	D
2074	D1	201617	2016-09-09	Schalke 04	Bayern Munich	0	2	A	0	0	D
2075	D1	201617	2016-09-10	Darmstadt	Ein Frankfurt	1	0	H	0	0	D
2076	D1	201617	2016-09-10	Freiburg	M'gladbach	3	1	H	0	1	A
2077	D1	201617	2016-09-10	Ingolstadt	Hertha	0	2	A	0	1	A
2078	D1	201617	2016-09-10	Leverkusen	Hamburg	3	1	H	0	0	D
2079	D1	201617	2016-09-10	RB Leipzig	Dortmund	1	0	H	0	0	D
2080	D1	201617	2016-09-10	Wolfsburg	FC Koln	0	0	D	0	0	D
2081	D1	201617	2016-09-11	Mainz	Hoffenheim	4	4	D	4	1	H
2082	D1	201617	2016-09-11	Werder Bremen	Augsburg	1	2	A	1	0	H
2083	D1	201617	2016-09-16	FC Koln	Freiburg	3	0	H	3	0	H
2084	D1	201617	2016-09-17	Bayern Munich	Ingolstadt	3	1	H	1	1	D
2085	D1	201617	2016-09-17	Dortmund	Darmstadt	6	0	H	1	0	H
2086	D1	201617	2016-09-17	Ein Frankfurt	Leverkusen	2	1	H	0	0	D
2087	D1	201617	2016-09-17	Hamburg	RB Leipzig	0	4	A	0	0	D
2088	D1	201617	2016-09-17	Hoffenheim	Wolfsburg	0	0	D	0	0	D
2089	D1	201617	2016-09-17	M'gladbach	Werder Bremen	4	1	H	4	0	H
2090	D1	201617	2016-09-18	Augsburg	Mainz	1	3	A	0	1	A
2091	D1	201617	2016-09-18	Hertha	Schalke 04	2	0	H	0	0	D
2092	D1	201617	2016-09-20	Darmstadt	Hoffenheim	1	1	D	0	0	D
2093	D1	201617	2016-09-20	Freiburg	Hamburg	1	0	H	0	0	D
2094	D1	201617	2016-09-20	Ingolstadt	Ein Frankfurt	0	2	A	0	1	A
2095	D1	201617	2016-09-20	Wolfsburg	Dortmund	1	5	A	0	2	A
2096	D1	201617	2016-09-21	Bayern Munich	Hertha	3	0	H	1	0	H
2097	D1	201617	2016-09-21	Leverkusen	Augsburg	0	0	D	0	0	D
2098	D1	201617	2016-09-21	RB Leipzig	M'gladbach	1	1	D	1	0	H
2099	D1	201617	2016-09-21	Schalke 04	FC Koln	1	3	A	1	1	D
2100	D1	201617	2016-09-21	Werder Bremen	Mainz	1	2	A	1	0	H
2101	D1	201617	2016-09-23	Dortmund	Freiburg	3	1	H	1	0	H
2102	D1	201617	2016-09-24	Augsburg	Darmstadt	1	0	H	0	0	D
2103	D1	201617	2016-09-24	Ein Frankfurt	Hertha	3	3	D	2	1	H
2104	D1	201617	2016-09-24	Hamburg	Bayern Munich	0	1	A	0	0	D
2105	D1	201617	2016-09-24	Mainz	Leverkusen	2	3	A	2	1	H
2106	D1	201617	2016-09-24	M'gladbach	Ingolstadt	2	0	H	1	0	H
2107	D1	201617	2016-09-24	Werder Bremen	Wolfsburg	2	1	H	0	0	D
2108	D1	201617	2016-09-25	FC Koln	RB Leipzig	1	1	D	1	1	D
2109	D1	201617	2016-09-25	Hoffenheim	Schalke 04	2	1	H	2	1	H
2110	D1	201617	2016-09-30	RB Leipzig	Augsburg	2	1	H	1	1	D
2111	D1	201617	2016-10-01	Bayern Munich	FC Koln	1	1	D	1	0	H
2112	D1	201617	2016-10-01	Darmstadt	Werder Bremen	2	2	D	1	0	H
2113	D1	201617	2016-10-01	Freiburg	Ein Frankfurt	1	0	H	1	0	H
2114	D1	201617	2016-10-01	Hertha	Hamburg	2	0	H	1	0	H
2115	D1	201617	2016-10-01	Ingolstadt	Hoffenheim	1	2	A	0	2	A
2116	D1	201617	2016-10-01	Leverkusen	Dortmund	2	0	H	1	0	H
2117	D1	201617	2016-10-02	Schalke 04	M'gladbach	4	0	H	0	0	D
2118	D1	201617	2016-10-02	Wolfsburg	Mainz	0	0	D	0	0	D
2119	D1	201617	2016-10-14	Dortmund	Hertha	1	1	D	0	0	D
2120	D1	201617	2016-10-15	Augsburg	Schalke 04	1	1	D	0	0	D
2121	D1	201617	2016-10-15	Ein Frankfurt	Bayern Munich	2	2	D	1	1	D
2122	D1	201617	2016-10-15	FC Koln	Ingolstadt	2	1	H	2	0	H
2123	D1	201617	2016-10-15	Hoffenheim	Freiburg	2	1	H	1	0	H
2124	D1	201617	2016-10-15	M'gladbach	Hamburg	0	0	D	0	0	D
2125	D1	201617	2016-10-15	Werder Bremen	Leverkusen	2	1	H	1	1	D
2126	D1	201617	2016-10-16	Mainz	Darmstadt	2	1	H	1	0	H
2127	D1	201617	2016-10-16	Wolfsburg	RB Leipzig	0	1	A	0	0	D
2128	D1	201617	2016-10-21	Hamburg	Ein Frankfurt	0	3	A	0	1	A
2129	D1	201617	2016-10-22	Bayern Munich	M'gladbach	2	0	H	2	0	H
2130	D1	201617	2016-10-22	Darmstadt	Wolfsburg	3	1	H	1	0	H
2131	D1	201617	2016-10-22	Freiburg	Augsburg	2	1	H	0	0	D
2132	D1	201617	2016-10-22	Hertha	FC Koln	2	1	H	1	0	H
2133	D1	201617	2016-10-22	Ingolstadt	Dortmund	3	3	D	2	0	H
2134	D1	201617	2016-10-22	Leverkusen	Hoffenheim	0	3	A	0	1	A
2135	D1	201617	2016-10-23	RB Leipzig	Werder Bremen	3	1	H	1	0	H
2136	D1	201617	2016-10-23	Schalke 04	Mainz	3	0	H	1	0	H
2137	D1	201617	2016-10-28	M'gladbach	Ein Frankfurt	0	0	D	0	0	D
2138	D1	201617	2016-10-29	Augsburg	Bayern Munich	1	3	A	0	2	A
2139	D1	201617	2016-10-29	Darmstadt	RB Leipzig	0	2	A	0	0	D
2140	D1	201617	2016-10-29	Dortmund	Schalke 04	0	0	D	0	0	D
2141	D1	201617	2016-10-29	Mainz	Ingolstadt	2	0	H	0	0	D
2142	D1	201617	2016-10-29	Werder Bremen	Freiburg	1	3	A	0	2	A
2143	D1	201617	2016-10-29	Wolfsburg	Leverkusen	1	2	A	1	0	H
2144	D1	201617	2016-10-30	FC Koln	Hamburg	3	0	H	0	0	D
2145	D1	201617	2016-10-30	Hoffenheim	Hertha	1	0	H	1	0	H
2146	D1	201617	2016-11-04	Hertha	M'gladbach	3	0	H	2	0	H
2147	D1	201617	2016-11-05	Bayern Munich	Hoffenheim	1	1	D	1	1	D
2148	D1	201617	2016-11-05	Ein Frankfurt	FC Koln	1	0	H	1	0	H
2149	D1	201617	2016-11-05	Freiburg	Wolfsburg	0	3	A	0	1	A
2150	D1	201617	2016-11-05	Hamburg	Dortmund	2	5	A	0	3	A
2151	D1	201617	2016-11-05	Ingolstadt	Augsburg	0	2	A	0	0	D
2152	D1	201617	2016-11-05	Leverkusen	Darmstadt	3	2	H	1	0	H
2153	D1	201617	2016-11-06	RB Leipzig	Mainz	3	1	H	3	0	H
2154	D1	201617	2016-11-06	Schalke 04	Werder Bremen	3	1	H	2	1	H
2155	D1	201617	2016-11-18	Leverkusen	RB Leipzig	2	3	A	2	1	H
2156	D1	201617	2016-11-19	Augsburg	Hertha	0	0	D	0	0	D
2157	D1	201617	2016-11-19	Darmstadt	Ingolstadt	0	1	A	0	0	D
2158	D1	201617	2016-11-19	Dortmund	Bayern Munich	1	0	H	1	0	H
2159	D1	201617	2016-11-19	Mainz	Freiburg	4	2	H	2	0	H
2160	D1	201617	2016-11-19	M'gladbach	FC Koln	1	2	A	1	0	H
2161	D1	201617	2016-11-19	Wolfsburg	Schalke 04	0	1	A	0	0	D
2162	D1	201617	2016-11-20	Hoffenheim	Hamburg	2	2	D	1	1	D
2163	D1	201617	2016-11-20	Werder Bremen	Ein Frankfurt	1	2	A	1	0	H
2164	D1	201617	2016-11-25	Freiburg	RB Leipzig	1	4	A	1	3	A
2165	D1	201617	2016-11-26	Bayern Munich	Leverkusen	2	1	H	1	1	D
2166	D1	201617	2016-11-26	Ein Frankfurt	Dortmund	2	1	H	0	0	D
2167	D1	201617	2016-11-26	FC Koln	Augsburg	0	0	D	0	0	D
2168	D1	201617	2016-11-26	Hamburg	Werder Bremen	2	2	D	2	2	D
2169	D1	201617	2016-11-26	Ingolstadt	Wolfsburg	1	1	D	1	0	H
2170	D1	201617	2016-11-26	M'gladbach	Hoffenheim	1	1	D	1	0	H
2171	D1	201617	2016-11-27	Hertha	Mainz	2	1	H	1	1	D
2172	D1	201617	2016-11-27	Schalke 04	Darmstadt	3	1	H	1	1	D
2173	D1	201617	2016-12-02	Mainz	Bayern Munich	1	3	A	1	2	A
2174	D1	201617	2016-12-03	Dortmund	M'gladbach	4	1	H	2	1	H
2175	D1	201617	2016-12-03	Hoffenheim	FC Koln	4	0	H	2	0	H
2176	D1	201617	2016-12-03	Leverkusen	Freiburg	1	1	D	0	1	A
2177	D1	201617	2016-12-03	RB Leipzig	Schalke 04	2	1	H	1	1	D
2178	D1	201617	2016-12-03	Werder Bremen	Ingolstadt	2	1	H	1	0	H
2179	D1	201617	2016-12-03	Wolfsburg	Hertha	2	3	A	2	1	H
2180	D1	201617	2016-12-04	Augsburg	Ein Frankfurt	1	1	D	1	1	D
2181	D1	201617	2016-12-04	Darmstadt	Hamburg	0	2	A	0	1	A
2182	D1	201617	2016-12-09	Ein Frankfurt	Hoffenheim	0	0	D	0	0	D
2183	D1	201617	2016-12-10	Bayern Munich	Wolfsburg	5	0	H	2	0	H
2184	D1	201617	2016-12-10	FC Koln	Dortmund	1	1	D	1	0	H
2185	D1	201617	2016-12-10	Freiburg	Darmstadt	1	0	H	0	0	D
2186	D1	201617	2016-12-10	Hamburg	Augsburg	1	0	H	0	0	D
2187	D1	201617	2016-12-10	Hertha	Werder Bremen	0	1	A	0	1	A
2188	D1	201617	2016-12-10	Ingolstadt	RB Leipzig	1	0	H	1	0	H
2189	D1	201617	2016-12-11	M'gladbach	Mainz	1	0	H	0	0	D
2190	D1	201617	2016-12-11	Schalke 04	Leverkusen	0	1	A	0	0	D
2191	D1	201617	2016-12-16	Hoffenheim	Dortmund	2	2	D	2	1	H
2192	D1	201617	2016-12-17	Augsburg	M'gladbach	1	0	H	0	0	D
2193	D1	201617	2016-12-17	Mainz	Hamburg	3	1	H	1	1	D
2194	D1	201617	2016-12-17	RB Leipzig	Hertha	2	0	H	1	0	H
2195	D1	201617	2016-12-17	Schalke 04	Freiburg	1	1	D	0	0	D
2196	D1	201617	2016-12-17	Werder Bremen	FC Koln	1	1	D	1	1	D
2197	D1	201617	2016-12-17	Wolfsburg	Ein Frankfurt	1	0	H	1	0	H
2198	D1	201617	2016-12-18	Darmstadt	Bayern Munich	0	1	A	0	0	D
2199	D1	201617	2016-12-18	Leverkusen	Ingolstadt	1	2	A	0	1	A
2200	D1	201617	2016-12-20	Dortmund	Augsburg	1	1	D	0	1	A
2201	D1	201617	2016-12-20	Ein Frankfurt	Mainz	3	0	H	1	0	H
2202	D1	201617	2016-12-20	Hamburg	Schalke 04	2	1	H	0	0	D
2203	D1	201617	2016-12-20	M'gladbach	Wolfsburg	1	2	A	0	1	A
2204	D1	201617	2016-12-21	Bayern Munich	RB Leipzig	3	0	H	3	0	H
2205	D1	201617	2016-12-21	FC Koln	Leverkusen	1	1	D	1	1	D
2206	D1	201617	2016-12-21	Hertha	Darmstadt	2	0	H	0	0	D
2207	D1	201617	2016-12-21	Hoffenheim	Werder Bremen	1	1	D	1	0	H
2208	D1	201617	2016-12-21	Ingolstadt	Freiburg	1	2	A	0	2	A
2209	D1	201617	2017-01-20	Freiburg	Bayern Munich	1	2	A	1	1	D
2210	D1	201617	2017-01-21	Augsburg	Hoffenheim	0	2	A	0	0	D
2211	D1	201617	2017-01-21	Darmstadt	M'gladbach	0	0	D	0	0	D
2212	D1	201617	2017-01-21	RB Leipzig	Ein Frankfurt	3	0	H	2	0	H
2213	D1	201617	2017-01-21	Schalke 04	Ingolstadt	1	0	H	0	0	D
2214	D1	201617	2017-01-21	Werder Bremen	Dortmund	1	2	A	0	1	A
2215	D1	201617	2017-01-21	Wolfsburg	Hamburg	1	0	H	0	0	D
2216	D1	201617	2017-01-22	Leverkusen	Hertha	3	1	H	2	1	H
2217	D1	201617	2017-01-22	Mainz	FC Koln	0	0	D	0	0	D
2218	D1	201617	2017-01-27	Schalke 04	Ein Frankfurt	0	1	A	0	1	A
2219	D1	201617	2017-01-28	Darmstadt	FC Koln	1	6	A	0	3	A
2220	D1	201617	2017-01-28	Ingolstadt	Hamburg	3	1	H	2	0	H
2221	D1	201617	2017-01-28	Leverkusen	M'gladbach	2	3	A	2	0	H
2222	D1	201617	2017-01-28	RB Leipzig	Hoffenheim	2	1	H	1	1	D
2223	D1	201617	2017-01-28	Werder Bremen	Bayern Munich	1	2	A	0	2	A
2224	D1	201617	2017-01-28	Wolfsburg	Augsburg	1	2	A	1	1	D
2225	D1	201617	2017-01-29	Freiburg	Hertha	2	1	H	1	0	H
2226	D1	201617	2017-01-29	Mainz	Dortmund	1	1	D	0	1	A
2227	D1	201617	2017-02-03	Hamburg	Leverkusen	1	0	H	0	0	D
2228	D1	201617	2017-02-04	Bayern Munich	Schalke 04	1	1	D	1	1	D
2229	D1	201617	2017-02-04	Dortmund	RB Leipzig	1	0	H	1	0	H
2230	D1	201617	2017-02-04	FC Koln	Wolfsburg	1	0	H	0	0	D
2231	D1	201617	2017-02-04	Hertha	Ingolstadt	1	0	H	1	0	H
2232	D1	201617	2017-02-04	Hoffenheim	Mainz	4	0	H	1	0	H
2233	D1	201617	2017-02-04	M'gladbach	Freiburg	3	0	H	0	0	D
2234	D1	201617	2017-02-05	Augsburg	Werder Bremen	3	2	H	1	1	D
2235	D1	201617	2017-02-05	Ein Frankfurt	Darmstadt	2	0	H	0	0	D
2236	D1	201617	2017-02-10	Mainz	Augsburg	2	0	H	1	0	H
2237	D1	201617	2017-02-11	Darmstadt	Dortmund	2	1	H	1	1	D
2238	D1	201617	2017-02-11	Ingolstadt	Bayern Munich	0	2	A	0	0	D
2239	D1	201617	2017-02-11	Leverkusen	Ein Frankfurt	3	0	H	1	0	H
2240	D1	201617	2017-02-11	RB Leipzig	Hamburg	0	3	A	0	2	A
2241	D1	201617	2017-02-11	Schalke 04	Hertha	2	0	H	1	0	H
2242	D1	201617	2017-02-11	Werder Bremen	M'gladbach	0	1	A	0	1	A
2243	D1	201617	2017-02-12	Freiburg	FC Koln	2	1	H	1	1	D
2244	D1	201617	2017-02-12	Wolfsburg	Hoffenheim	2	1	H	0	1	A
2245	D1	201617	2017-02-17	Augsburg	Leverkusen	1	3	A	0	2	A
2246	D1	201617	2017-02-18	Dortmund	Wolfsburg	3	0	H	1	0	H
2247	D1	201617	2017-02-18	Ein Frankfurt	Ingolstadt	0	2	A	0	1	A
2248	D1	201617	2017-02-18	Hamburg	Freiburg	2	2	D	1	1	D
2249	D1	201617	2017-02-18	Hertha	Bayern Munich	1	1	D	1	0	H
2250	D1	201617	2017-02-18	Hoffenheim	Darmstadt	2	0	H	0	0	D
2251	D1	201617	2017-02-18	Mainz	Werder Bremen	0	2	A	0	2	A
2252	D1	201617	2017-02-19	FC Koln	Schalke 04	1	1	D	1	1	D
2253	D1	201617	2017-02-19	M'gladbach	RB Leipzig	1	2	A	0	1	A
2254	D1	201617	2017-02-24	Wolfsburg	Werder Bremen	1	2	A	1	2	A
2255	D1	201617	2017-02-25	Bayern Munich	Hamburg	8	0	H	3	0	H
2256	D1	201617	2017-02-25	Darmstadt	Augsburg	1	2	A	0	0	D
2257	D1	201617	2017-02-25	Freiburg	Dortmund	0	3	A	0	1	A
2258	D1	201617	2017-02-25	Hertha	Ein Frankfurt	2	0	H	0	0	D
2259	D1	201617	2017-02-25	Leverkusen	Mainz	0	2	A	0	2	A
2260	D1	201617	2017-02-25	RB Leipzig	FC Koln	3	1	H	2	0	H
2261	D1	201617	2017-02-26	Ingolstadt	M'gladbach	0	2	A	0	0	D
2262	D1	201617	2017-02-26	Schalke 04	Hoffenheim	1	1	D	1	0	H
2263	D1	201617	2017-03-03	Augsburg	RB Leipzig	2	2	D	1	1	D
2264	D1	201617	2017-03-04	Dortmund	Leverkusen	6	2	H	2	0	H
2265	D1	201617	2017-03-04	FC Koln	Bayern Munich	0	3	A	0	1	A
2266	D1	201617	2017-03-04	Hoffenheim	Ingolstadt	5	2	H	1	1	D
2267	D1	201617	2017-03-04	Mainz	Wolfsburg	1	1	D	1	1	D
2268	D1	201617	2017-03-04	M'gladbach	Schalke 04	4	2	H	1	1	D
2269	D1	201617	2017-03-04	Werder Bremen	Darmstadt	2	0	H	0	0	D
2270	D1	201617	2017-03-05	Ein Frankfurt	Freiburg	1	2	A	1	1	D
2271	D1	201617	2017-03-05	Hamburg	Hertha	1	0	H	0	0	D
2272	D1	201617	2017-03-10	Leverkusen	Werder Bremen	1	1	D	1	0	H
2273	D1	201617	2017-03-11	Bayern Munich	Ein Frankfurt	3	0	H	2	0	H
2274	D1	201617	2017-03-11	Darmstadt	Mainz	2	1	H	2	1	H
2275	D1	201617	2017-03-11	Freiburg	Hoffenheim	1	1	D	0	0	D
2276	D1	201617	2017-03-11	Hertha	Dortmund	2	1	H	1	0	H
2277	D1	201617	2017-03-11	Ingolstadt	FC Koln	2	2	D	1	1	D
2278	D1	201617	2017-03-11	RB Leipzig	Wolfsburg	0	1	A	0	1	A
2279	D1	201617	2017-03-12	Hamburg	M'gladbach	2	1	H	1	1	D
2280	D1	201617	2017-03-12	Schalke 04	Augsburg	3	0	H	3	0	H
2281	D1	201617	2017-03-17	Dortmund	Ingolstadt	1	0	H	1	0	H
2282	D1	201617	2017-03-18	Augsburg	Freiburg	1	1	D	1	1	D
2283	D1	201617	2017-03-18	Ein Frankfurt	Hamburg	0	0	D	0	0	D
2284	D1	201617	2017-03-18	FC Koln	Hertha	4	2	H	3	0	H
2285	D1	201617	2017-03-18	Hoffenheim	Leverkusen	1	0	H	0	0	D
2286	D1	201617	2017-03-18	Werder Bremen	RB Leipzig	3	0	H	1	0	H
2287	D1	201617	2017-03-18	Wolfsburg	Darmstadt	1	0	H	1	0	H
2288	D1	201617	2017-03-19	Mainz	Schalke 04	0	1	A	0	0	D
2289	D1	201617	2017-03-19	M'gladbach	Bayern Munich	0	1	A	0	0	D
2290	D1	201617	2017-03-31	Hertha	Hoffenheim	1	3	A	1	1	D
2291	D1	201617	2017-04-01	Bayern Munich	Augsburg	6	0	H	2	0	H
2292	D1	201617	2017-04-01	Ein Frankfurt	M'gladbach	0	0	D	0	0	D
2293	D1	201617	2017-04-01	Freiburg	Werder Bremen	2	5	A	0	2	A
2294	D1	201617	2017-04-01	Hamburg	FC Koln	2	1	H	1	1	D
2295	D1	201617	2017-04-01	RB Leipzig	Darmstadt	4	0	H	1	0	H
2296	D1	201617	2017-04-01	Schalke 04	Dortmund	1	1	D	0	0	D
2297	D1	201617	2017-04-02	Ingolstadt	Mainz	2	1	H	1	0	H
2298	D1	201617	2017-04-02	Leverkusen	Wolfsburg	3	3	D	1	0	H
2299	D1	201617	2017-04-04	Dortmund	Hamburg	3	0	H	1	0	H
2300	D1	201617	2017-04-04	FC Koln	Ein Frankfurt	1	0	H	0	0	D
2301	D1	201617	2017-04-04	Hoffenheim	Bayern Munich	1	0	H	1	0	H
2302	D1	201617	2017-04-04	Werder Bremen	Schalke 04	3	0	H	1	0	H
2303	D1	201617	2017-04-05	Augsburg	Ingolstadt	2	3	A	0	2	A
2304	D1	201617	2017-04-05	Darmstadt	Leverkusen	0	2	A	0	1	A
2305	D1	201617	2017-04-05	Mainz	RB Leipzig	2	3	A	0	0	D
2306	D1	201617	2017-04-05	M'gladbach	Hertha	1	0	H	1	0	H
2307	D1	201617	2017-04-05	Wolfsburg	Freiburg	0	1	A	0	0	D
2308	D1	201617	2017-04-07	Ein Frankfurt	Werder Bremen	2	2	D	0	2	A
2309	D1	201617	2017-04-08	Bayern Munich	Dortmund	4	1	H	2	1	H
2310	D1	201617	2017-04-08	FC Koln	M'gladbach	2	3	A	1	1	D
2311	D1	201617	2017-04-08	Freiburg	Mainz	1	0	H	0	0	D
2312	D1	201617	2017-04-08	Hamburg	Hoffenheim	2	1	H	1	1	D
2313	D1	201617	2017-04-08	RB Leipzig	Leverkusen	1	0	H	0	0	D
2314	D1	201617	2017-04-08	Schalke 04	Wolfsburg	4	1	H	2	0	H
2315	D1	201617	2017-04-09	Hertha	Augsburg	2	0	H	2	0	H
2316	D1	201617	2017-04-09	Ingolstadt	Darmstadt	3	2	H	1	2	A
2317	D1	201617	2017-04-15	Augsburg	FC Koln	2	1	H	2	0	H
2318	D1	201617	2017-04-15	Dortmund	Ein Frankfurt	3	1	H	2	1	H
2319	D1	201617	2017-04-15	Hoffenheim	M'gladbach	5	3	H	2	2	D
2320	D1	201617	2017-04-15	Leverkusen	Bayern Munich	0	0	D	0	0	D
2321	D1	201617	2017-04-15	Mainz	Hertha	1	0	H	1	0	H
2322	D1	201617	2017-04-15	RB Leipzig	Freiburg	4	0	H	2	0	H
2323	D1	201617	2017-04-15	Wolfsburg	Ingolstadt	3	0	H	1	0	H
2324	D1	201617	2017-04-16	Darmstadt	Schalke 04	2	1	H	1	0	H
2325	D1	201617	2017-04-16	Werder Bremen	Hamburg	2	1	H	1	1	D
2326	D1	201617	2017-04-21	FC Koln	Hoffenheim	1	1	D	0	0	D
2327	D1	201617	2017-04-22	Bayern Munich	Mainz	2	2	D	1	2	A
2328	D1	201617	2017-04-22	Ein Frankfurt	Augsburg	3	1	H	0	1	A
2329	D1	201617	2017-04-22	Hamburg	Darmstadt	1	2	A	0	0	D
2330	D1	201617	2017-04-22	Hertha	Wolfsburg	1	0	H	0	0	D
2331	D1	201617	2017-04-22	Ingolstadt	Werder Bremen	2	4	A	1	1	D
2332	D1	201617	2017-04-22	M'gladbach	Dortmund	2	3	A	1	1	D
2333	D1	201617	2017-04-23	Freiburg	Leverkusen	2	1	H	1	0	H
2334	D1	201617	2017-04-23	Schalke 04	RB Leipzig	1	1	D	0	1	A
2335	D1	201617	2017-04-28	Leverkusen	Schalke 04	1	4	A	0	3	A
2336	D1	201617	2017-04-29	Darmstadt	Freiburg	3	0	H	2	0	H
2337	D1	201617	2017-04-29	Dortmund	FC Koln	0	0	D	0	0	D
2338	D1	201617	2017-04-29	Mainz	M'gladbach	1	2	A	0	1	A
2339	D1	201617	2017-04-29	RB Leipzig	Ingolstadt	0	0	D	0	0	D
2340	D1	201617	2017-04-29	Werder Bremen	Hertha	2	0	H	2	0	H
2341	D1	201617	2017-04-29	Wolfsburg	Bayern Munich	0	6	A	0	3	A
2342	D1	201617	2017-04-30	Augsburg	Hamburg	4	0	H	2	0	H
2343	D1	201617	2017-04-30	Hoffenheim	Ein Frankfurt	1	0	H	0	0	D
2344	D1	201617	2017-05-05	FC Koln	Werder Bremen	4	3	H	3	2	H
2345	D1	201617	2017-05-06	Bayern Munich	Darmstadt	1	0	H	1	0	H
2346	D1	201617	2017-05-06	Dortmund	Hoffenheim	2	1	H	1	0	H
2347	D1	201617	2017-05-06	Ein Frankfurt	Wolfsburg	0	2	A	0	0	D
2348	D1	201617	2017-05-06	Hertha	RB Leipzig	1	4	A	0	1	A
2349	D1	201617	2017-05-06	Ingolstadt	Leverkusen	1	1	D	0	0	D
2350	D1	201617	2017-05-06	M'gladbach	Augsburg	1	1	D	0	0	D
2351	D1	201617	2017-05-07	Freiburg	Schalke 04	2	0	H	2	0	H
2352	D1	201617	2017-05-07	Hamburg	Mainz	0	0	D	0	0	D
2353	D1	201617	2017-05-13	Augsburg	Dortmund	1	1	D	1	1	D
2354	D1	201617	2017-05-13	Darmstadt	Hertha	0	2	A	0	2	A
2355	D1	201617	2017-05-13	Freiburg	Ingolstadt	1	1	D	1	1	D
2356	D1	201617	2017-05-13	Leverkusen	FC Koln	2	2	D	0	1	A
2357	D1	201617	2017-05-13	Mainz	Ein Frankfurt	4	2	H	0	1	A
2358	D1	201617	2017-05-13	RB Leipzig	Bayern Munich	4	5	A	2	1	H
2359	D1	201617	2017-05-13	Schalke 04	Hamburg	1	1	D	1	0	H
2360	D1	201617	2017-05-13	Werder Bremen	Hoffenheim	3	5	A	0	3	A
2361	D1	201617	2017-05-13	Wolfsburg	M'gladbach	1	1	D	0	1	A
2362	D1	201617	2017-05-20	Bayern Munich	Freiburg	4	1	H	1	0	H
2363	D1	201617	2017-05-20	Dortmund	Werder Bremen	4	3	H	2	1	H
2364	D1	201617	2017-05-20	Ein Frankfurt	RB Leipzig	2	2	D	0	1	A
2365	D1	201617	2017-05-20	FC Koln	Mainz	2	0	H	1	0	H
2366	D1	201617	2017-05-20	Hamburg	Wolfsburg	2	1	H	1	1	D
2367	D1	201617	2017-05-20	Hertha	Leverkusen	2	6	A	0	3	A
2368	D1	201617	2017-05-20	Hoffenheim	Augsburg	0	0	D	0	0	D
2369	D1	201617	2017-05-20	Ingolstadt	Schalke 04	1	1	D	1	1	D
2370	D1	201617	2017-05-20	M'gladbach	Darmstadt	2	2	D	0	0	D
13	SP1	201617	2016-08-27	Eibar	Valencia	1	0	H	0	0	D
33	SP1	201617	2016-09-17	Eibar	Sevilla	1	1	D	0	1	A
53	SP1	201617	2016-09-24	Eibar	Sociedad	2	0	H	0	0	D
80	SP1	201617	2016-10-17	Eibar	Osasuna	2	3	A	2	2	D
98	SP1	201617	2016-10-30	Eibar	Villarreal	2	1	H	0	1	A
114	SP1	201617	2016-11-19	Eibar	Celta	1	0	H	1	0	H
121	SP1	201617	2016-11-25	Eibar	Betis	3	1	H	2	0	H
148	SP1	201617	2016-12-11	Eibar	Alaves	0	0	D	0	0	D
161	SP1	201617	2017-01-07	Eibar	Ath Madrid	0	2	A	0	0	D
187	SP1	201617	2017-01-22	Eibar	Barcelona	0	4	A	0	1	A
192	SP1	201617	2017-01-28	Eibar	La Coruna	3	1	H	2	1	H
217	SP1	201617	2017-02-13	Eibar	Granada	4	0	H	2	0	H
232	SP1	201617	2017-02-25	Eibar	Malaga	3	0	H	1	0	H
251	SP1	201617	2017-03-04	Eibar	Real Madrid	1	4	A	0	3	A
274	SP1	201617	2017-03-18	Eibar	Espanol	1	1	D	1	0	H
298	SP1	201617	2017-04-06	Eibar	Las Palmas	3	1	H	2	0	H
329	SP1	201617	2017-04-24	Eibar	Ath Bilbao	0	1	A	0	0	D
478	SP1	201516	2015-11-01	Eibar	Vallecano	1	0	H	1	0	H
483	SP1	201516	2015-11-07	Eibar	Getafe	3	1	H	2	1	H
507	SP1	201516	2015-11-29	Eibar	Real Madrid	0	2	A	0	1	A
528	SP1	201516	2015-12-13	Eibar	Valencia	1	1	D	1	0	H
542	SP1	201516	2015-12-30	Eibar	Sp Gijon	2	0	H	0	0	D
566	SP1	201516	2016-01-10	Eibar	Espanol	2	1	H	1	1	D
579	SP1	201516	2016-01-18	Eibar	Granada	5	1	H	2	0	H
591	SP1	201516	2016-01-30	Eibar	Malaga	1	2	A	0	1	A
616	SP1	201516	2016-02-14	Eibar	Levante	2	0	H	1	0	H
631	SP1	201516	2016-02-26	Eibar	Las Palmas	0	1	A	0	1	A
656	SP1	201516	2016-03-06	Eibar	Barcelona	0	4	A	0	2	A
687	SP1	201516	2016-04-03	Eibar	Villarreal	1	2	A	1	1	D
724	SP1	201516	2016-04-23	Eibar	La Coruna	1	1	D	1	0	H
743	SP1	201516	2016-05-08	Eibar	Betis	1	1	D	0	1	A
365	SP1	201617	2017-05-14	Eibar	Sp Gijon	0	1	A	0	1	A
396	SP1	201516	2015-08-30	Eibar	Ath Bilbao	2	0	H	1	0	H
412	SP1	201516	2015-09-19	Eibar	Ath Madrid	0	2	A	0	0	D
433	SP1	201516	2015-09-26	Eibar	Celta	1	1	D	1	0	H
453	SP1	201516	2015-10-17	Eibar	Sevilla	1	1	D	1	0	H
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20190601151424	2019-06-01 15:20:00
20190602140106	2019-06-02 14:05:38
20190602140631	2019-06-02 14:41:08
\.


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matches_id_seq', 1, false);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: matches_division_season_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX matches_division_season_index ON public.matches USING btree (division, season);


--
-- PostgreSQL database dump complete
--

