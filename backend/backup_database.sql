--
-- PostgreSQL database dump
--

\restrict zZ5NHQ93zcjIT3HeMo5Nw29ZcNxkRB8O4AH8kTQd7k6HUWb2pLuPerl4lr6trMS

-- Dumped from database version 17.10 (2947584)
-- Dumped by pg_dump version 18.3 (Postgres.app)

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
-- Name: neon_auth; Type: SCHEMA; Schema: -; Owner: neon_auth
--

CREATE SCHEMA neon_auth;


ALTER SCHEMA neon_auth OWNER TO neon_auth;

--
-- Name: pgrst; Type: SCHEMA; Schema: -; Owner: neon_service
--

CREATE SCHEMA pgrst;


ALTER SCHEMA pgrst OWNER TO neon_service;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: neondb_owner
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO neondb_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: neondb_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: Role; Type: TYPE; Schema: public; Owner: neondb_owner
--

CREATE TYPE public."Role" AS ENUM (
    'SUPER_ADMIN',
    'ADMIN',
    'COACH',
    'PARENT',
    'PLAYER'
);


ALTER TYPE public."Role" OWNER TO neondb_owner;

--
-- Name: pre_config(); Type: FUNCTION; Schema: pgrst; Owner: neon_service
--

CREATE FUNCTION pgrst.pre_config() RETURNS void
    LANGUAGE sql
    SET search_path TO ''
    AS $$
  SELECT
      set_config('pgrst.db_schemas', 'public', true)
    , set_config('pgrst.db_aggregates_enabled', 'true', true)
    , set_config('pgrst.db_anon_role', 'anonymous', true)
    , set_config('pgrst.jwt_role_claim_key', '.role', true)
$$;


ALTER FUNCTION pgrst.pre_config() OWNER TO neon_service;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.account (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "accountId" text NOT NULL,
    "providerId" text NOT NULL,
    "userId" uuid NOT NULL,
    "accessToken" text,
    "refreshToken" text,
    "idToken" text,
    "accessTokenExpiresAt" timestamp with time zone,
    "refreshTokenExpiresAt" timestamp with time zone,
    scope text,
    password text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.account OWNER TO neon_auth;

--
-- Name: invitation; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.invitation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    email text NOT NULL,
    role text,
    status text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "inviterId" uuid NOT NULL
);


ALTER TABLE neon_auth.invitation OWNER TO neon_auth;

--
-- Name: jwks; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.jwks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "publicKey" text NOT NULL,
    "privateKey" text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "expiresAt" timestamp with time zone
);


ALTER TABLE neon_auth.jwks OWNER TO neon_auth;

--
-- Name: member; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.member (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    role text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.member OWNER TO neon_auth;

--
-- Name: organization; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.organization (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    logo text,
    "createdAt" timestamp with time zone NOT NULL,
    metadata text
);


ALTER TABLE neon_auth.organization OWNER TO neon_auth;

--
-- Name: project_config; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.project_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    endpoint_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    trusted_origins jsonb NOT NULL,
    social_providers jsonb NOT NULL,
    email_provider jsonb,
    email_and_password jsonb,
    allow_localhost boolean NOT NULL,
    plugin_configs jsonb,
    webhook_config jsonb
);


ALTER TABLE neon_auth.project_config OWNER TO neon_auth;

--
-- Name: session; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.session (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    token text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "userId" uuid NOT NULL,
    "impersonatedBy" text,
    "activeOrganizationId" text
);


ALTER TABLE neon_auth.session OWNER TO neon_auth;

--
-- Name: user; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth."user" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "emailVerified" boolean NOT NULL,
    image text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role text,
    banned boolean,
    "banReason" text,
    "banExpires" timestamp with time zone
);


ALTER TABLE neon_auth."user" OWNER TO neon_auth;

--
-- Name: verification; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.verification (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    identifier text NOT NULL,
    value text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE neon_auth.verification OWNER TO neon_auth;

--
-- Name: Attendance; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Attendance" (
    id text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    "groupId" text NOT NULL,
    "coachId" text,
    records jsonb NOT NULL
);


ALTER TABLE public."Attendance" OWNER TO neondb_owner;

--
-- Name: Coach; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Coach" (
    id text NOT NULL,
    "userId" text NOT NULL,
    specialty text,
    exp integer,
    cert text,
    salary double precision,
    "groupId" text,
    perms jsonb
);


ALTER TABLE public."Coach" OWNER TO neondb_owner;

--
-- Name: Evaluation; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Evaluation" (
    id text NOT NULL,
    "playerId" text NOT NULL,
    "coachId" text NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    note text,
    speed integer NOT NULL,
    technique integer NOT NULL,
    teamwork integer NOT NULL
);


ALTER TABLE public."Evaluation" OWNER TO neondb_owner;

--
-- Name: Group; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Group" (
    id text NOT NULL,
    name text NOT NULL,
    color text DEFAULT '#06B6D4'::text NOT NULL,
    "coachId" text
);


ALTER TABLE public."Group" OWNER TO neondb_owner;

--
-- Name: Message; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    "from" text NOT NULL,
    "to" text NOT NULL,
    "fromName" text NOT NULL,
    "toName" text NOT NULL,
    text text NOT NULL,
    files jsonb,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    read boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Message" OWNER TO neondb_owner;

--
-- Name: Parent; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Parent" (
    id text NOT NULL,
    "userId" text NOT NULL
);


ALTER TABLE public."Parent" OWNER TO neondb_owner;

--
-- Name: Payment; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Payment" (
    id text NOT NULL,
    "playerId" text NOT NULL,
    "playerName" text,
    "coachId" text,
    "coachName" text,
    type text NOT NULL,
    month text NOT NULL,
    amount double precision NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    note text,
    discount double precision DEFAULT 0
);


ALTER TABLE public."Payment" OWNER TO neondb_owner;

--
-- Name: Player; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Player" (
    id text NOT NULL,
    "userId" text,
    name text NOT NULL,
    age integer NOT NULL,
    phone text,
    status text DEFAULT 'نشط'::text NOT NULL,
    "position" text,
    weight double precision,
    height double precision,
    "joinDate" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    score integer DEFAULT 80 NOT NULL,
    speed integer DEFAULT 75 NOT NULL,
    stamina integer DEFAULT 75 NOT NULL,
    technique integer DEFAULT 75 NOT NULL,
    teamwork integer DEFAULT 75 NOT NULL,
    goals integer DEFAULT 0 NOT NULL,
    assists integer DEFAULT 0 NOT NULL,
    "attendancePct" integer DEFAULT 90 NOT NULL,
    "groupId" text NOT NULL,
    "parentId" text NOT NULL,
    bus text,
    "freezeRanges" text,
    "nationalId" text
);


ALTER TABLE public."Player" OWNER TO neondb_owner;

--
-- Name: Training; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."Training" (
    id text NOT NULL,
    "groupId" text NOT NULL,
    "coachId" text NOT NULL,
    days text[],
    "time" text NOT NULL,
    duration integer NOT NULL,
    field text NOT NULL,
    title text,
    "trainingFocus" text,
    note text,
    date timestamp(3) without time zone,
    "isRecurring" boolean DEFAULT true NOT NULL,
    type text DEFAULT 'training'::text NOT NULL,
    "isFriendly" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Training" OWNER TO neondb_owner;

--
-- Name: User; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    role public."Role" DEFAULT 'PARENT'::public."Role" NOT NULL,
    phone text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."User" OWNER TO neondb_owner;

--
-- Data for Name: account; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.account (id, "accountId", "providerId", "userId", "accessToken", "refreshToken", "idToken", "accessTokenExpiresAt", "refreshTokenExpiresAt", scope, password, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: invitation; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.invitation (id, "organizationId", email, role, status, "expiresAt", "createdAt", "inviterId") FROM stdin;
\.


--
-- Data for Name: jwks; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.jwks (id, "publicKey", "privateKey", "createdAt", "expiresAt") FROM stdin;
\.


--
-- Data for Name: member; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.member (id, "organizationId", "userId", role, "createdAt") FROM stdin;
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.organization (id, name, slug, logo, "createdAt", metadata) FROM stdin;
\.


--
-- Data for Name: project_config; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.project_config (id, name, endpoint_id, created_at, updated_at, trusted_origins, social_providers, email_provider, email_and_password, allow_localhost, plugin_configs, webhook_config) FROM stdin;
345dab39-00fa-4d0d-a0b8-36bff89eee2c	najd-club	ep-weathered-paper-aeyutoc9	2026-04-27 15:55:13.479+00	2026-04-27 15:55:13.479+00	[]	[{"id": "google", "isShared": true}]	{"type": "shared"}	{"enabled": true, "disableSignUp": false, "emailVerificationMethod": "otp", "requireEmailVerification": false, "autoSignInAfterVerification": true, "sendVerificationEmailOnSignIn": false, "sendVerificationEmailOnSignUp": false}	t	{"organization": {"config": {"creatorRole": "owner", "membershipLimit": 100, "organizationLimit": 10, "sendInvitationEmail": false}, "enabled": true}}	{"enabled": false, "enabledEvents": [], "timeoutSeconds": 5}
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.session (id, "expiresAt", token, "createdAt", "updatedAt", "ipAddress", "userAgent", "userId", "impersonatedBy", "activeOrganizationId") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth."user" (id, name, email, "emailVerified", image, "createdAt", "updatedAt", role, banned, "banReason", "banExpires") FROM stdin;
\.


--
-- Data for Name: verification; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

COPY neon_auth.verification (id, identifier, value, "expiresAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Attendance; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Attendance" (id, date, "groupId", "coachId", records) FROM stdin;
\.


--
-- Data for Name: Coach; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Coach" (id, "userId", specialty, exp, cert, salary, "groupId", perms) FROM stdin;
c-royal-coach	u-royal-coach	كرة قدم ناشئين	5	رخصة C الآسيوية	3000	g-royal-default	{"payments": false, "attendance": true}
\.


--
-- Data for Name: Evaluation; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Evaluation" (id, "playerId", "coachId", date, note, speed, technique, teamwork) FROM stdin;
\.


--
-- Data for Name: Group; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Group" (id, name, color, "coachId") FROM stdin;
g-royal-default	مجموعة 2017	#06B6D4	c-royal-coach
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Message" (id, "from", "to", "fromName", "toName", text, files, date, read) FROM stdin;
\.


--
-- Data for Name: Parent; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Parent" (id, "userId") FROM stdin;
par-royal-default	u-royal-parent
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Payment" (id, "playerId", "playerName", "coachId", "coachName", type, month, amount, date, note, discount) FROM stdin;
\.


--
-- Data for Name: Player; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Player" (id, "userId", name, age, phone, status, "position", weight, height, "joinDate", score, speed, stamina, technique, teamwork, goals, assists, "attendancePct", "groupId", "parentId", bus, "freezeRanges", "nationalId") FROM stdin;
p-royal-default	\N	أحمد خالد	9	0501234567	نشط	مهاجم	32	135	2026-06-26 14:37:25.622	80	75	75	75	75	0	0	90	g-royal-default	par-royal-default	\N	\N	\N
\.


--
-- Data for Name: Training; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."Training" (id, "groupId", "coachId", days, "time", duration, field, title, "trainingFocus", note, date, "isRecurring", type, "isFriendly") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public."User" (id, email, password, name, role, phone, "createdAt") FROM stdin;
super-admin	super@mohkam.sa	Mohkam@2026	إدارة محكم	SUPER_ADMIN	\N	2026-06-26 14:37:23.262
royal-admin-id	admin@royal.sa	Royal@2026	مدير أكاديمية رويال	ADMIN	\N	2026-06-26 14:37:23.864
u-royal-parent	parent@royal.sa	Parent@2026	ولي أمر أحمد خالد	PARENT	\N	2026-06-26 14:37:25.183
cmqv1neff0002bk6er8wss1hc	admin@ksa academy.com	Admin@ksa academy2026	مدير أكاديمية اكاديمية ksa	ADMIN	\N	2026-06-26 14:46:13.707
cmqv310060002o5b0fnuu2149	admin@najd.com	Admin@najd2026	مدير أكاديمية najd	ADMIN	\N	2026-06-26 15:24:47.814
u-royal-coach	coach@royal.sa	beb5fd70b157d31dfe276b9776bc8d7a:583b3cbfe23f3103d0e5bd7e5d3a252cd3abe22967967524a323c8ce5084882345ba159f124b0c4b1fe2a7d47509995ba4e9ab10f361c2ea08c6e05469ddb49e	الكابتن أحمد علي	COACH	\N	2026-06-26 14:37:24.439
\.


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (id);


--
-- Name: jwks jwks_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.jwks
    ADD CONSTRAINT jwks_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: organization organization_slug_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_slug_key UNIQUE (slug);


--
-- Name: project_config project_config_endpoint_id_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_endpoint_id_key UNIQUE (endpoint_id);


--
-- Name: project_config project_config_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session session_token_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_token_key UNIQUE (token);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: verification verification_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.verification
    ADD CONSTRAINT verification_pkey PRIMARY KEY (id);


--
-- Name: Attendance Attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Attendance"
    ADD CONSTRAINT "Attendance_pkey" PRIMARY KEY (id);


--
-- Name: Coach Coach_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Coach"
    ADD CONSTRAINT "Coach_pkey" PRIMARY KEY (id);


--
-- Name: Evaluation Evaluation_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Evaluation"
    ADD CONSTRAINT "Evaluation_pkey" PRIMARY KEY (id);


--
-- Name: Group Group_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Group"
    ADD CONSTRAINT "Group_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Parent Parent_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Parent"
    ADD CONSTRAINT "Parent_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: Player Player_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player"
    ADD CONSTRAINT "Player_pkey" PRIMARY KEY (id);


--
-- Name: Training Training_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Training"
    ADD CONSTRAINT "Training_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: account_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "account_userId_idx" ON neon_auth.account USING btree ("userId");


--
-- Name: invitation_email_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX invitation_email_idx ON neon_auth.invitation USING btree (email);


--
-- Name: invitation_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "invitation_organizationId_idx" ON neon_auth.invitation USING btree ("organizationId");


--
-- Name: member_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_organizationId_idx" ON neon_auth.member USING btree ("organizationId");


--
-- Name: member_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_userId_idx" ON neon_auth.member USING btree ("userId");


--
-- Name: organization_slug_uidx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE UNIQUE INDEX organization_slug_uidx ON neon_auth.organization USING btree (slug);


--
-- Name: session_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "session_userId_idx" ON neon_auth.session USING btree ("userId");


--
-- Name: verification_identifier_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX verification_identifier_idx ON neon_auth.verification USING btree (identifier);


--
-- Name: Coach_groupId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Coach_groupId_key" ON public."Coach" USING btree ("groupId");


--
-- Name: Coach_userId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Coach_userId_key" ON public."Coach" USING btree ("userId");


--
-- Name: Group_coachId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Group_coachId_key" ON public."Group" USING btree ("coachId");


--
-- Name: Parent_userId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Parent_userId_key" ON public."Parent" USING btree ("userId");


--
-- Name: Player_userId_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "Player_userId_key" ON public."Player" USING btree ("userId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: account account_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_inviterId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_inviterId_fkey" FOREIGN KEY ("inviterId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: session session_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: Attendance Attendance_coachId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Attendance"
    ADD CONSTRAINT "Attendance_coachId_fkey" FOREIGN KEY ("coachId") REFERENCES public."Coach"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Attendance Attendance_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Attendance"
    ADD CONSTRAINT "Attendance_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."Group"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Coach Coach_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Coach"
    ADD CONSTRAINT "Coach_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."Group"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Coach Coach_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Coach"
    ADD CONSTRAINT "Coach_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Evaluation Evaluation_coachId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Evaluation"
    ADD CONSTRAINT "Evaluation_coachId_fkey" FOREIGN KEY ("coachId") REFERENCES public."Coach"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Evaluation Evaluation_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Evaluation"
    ADD CONSTRAINT "Evaluation_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Player"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Parent Parent_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Parent"
    ADD CONSTRAINT "Parent_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Payment Payment_playerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES public."Player"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Player Player_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player"
    ADD CONSTRAINT "Player_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."Group"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Player Player_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player"
    ADD CONSTRAINT "Player_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Parent"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Player Player_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Player"
    ADD CONSTRAINT "Player_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Training Training_coachId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Training"
    ADD CONSTRAINT "Training_coachId_fkey" FOREIGN KEY ("coachId") REFERENCES public."Coach"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Training Training_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public."Training"
    ADD CONSTRAINT "Training_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."Group"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA pgrst; Type: ACL; Schema: -; Owner: neon_service
--

GRANT USAGE ON SCHEMA pgrst TO authenticator;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: neondb_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: FUNCTION pre_config(); Type: ACL; Schema: pgrst; Owner: neon_service
--

GRANT ALL ON FUNCTION pgrst.pre_config() TO authenticator;


--
-- PostgreSQL database dump complete
--

\unrestrict zZ5NHQ93zcjIT3HeMo5Nw29ZcNxkRB8O4AH8kTQd7k6HUWb2pLuPerl4lr6trMS

