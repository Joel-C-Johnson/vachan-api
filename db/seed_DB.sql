-- Script to create the basic table strcutures and 
-- add minimal seed data for vachan-api

CREATE TABLE public.content_types (
    content_type_id SERIAL PRIMARY KEY ,
    content_type text UNIQUE NOT NULL
);

INSERT INTO content_types(content_type) VALUES('bible');
INSERT INTO content_types(content_type) VALUES('commentary');
INSERT INTO content_types(content_type) VALUES('dictionary');
INSERT INTO content_types(content_type) VALUES('infographics');
INSERT INTO content_types(content_type) VALUES('bible_video');

CREATE TABLE public.languages (
    language_id SERIAL PRIMARY KEY,
    language_code char(3) UNIQUE NOT NULL,
    language_name text NOT NULL,
    script_direction text DEFAULT 'left-to-right'
);


\COPY languages (language_code,language_name) FROM 'languages.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.versions (
    version_id SERIAL PRIMARY KEY,
    version_code text NOT NULL,
    version_description text NOT NULL,
    revision integer DEFAULT 1,
    metadata jsonb,
    UNIQUE(version_code, revision)
);


CREATE TABLE public.sources (
    source_id SERIAL PRIMARY KEY,
    table_name text UNIQUE,
    year integer NOT NULL,
    license text DEFAULT 'CC BY SA'::text,
    content_id int NOT NULL REFERENCES content_types(content_type_id) ON DELETE CASCADE,
    language_id int NOT NULL REFERENCES languages(language_id) ON DELETE CASCADE,
    version_id int NOT NULL REFERENCES versions(version_id) ON DELETE CASCADE,
    created_at timestamp with time zone DEFAULT NOW(),
    created_user int NULL,
    last_updated_at  timestamp with time zone DEFAULT NOW(),
    last_updated_user int NULL,
    active boolean DEFAULT true NOT NULL,
    metadata jsonb NULL
);

