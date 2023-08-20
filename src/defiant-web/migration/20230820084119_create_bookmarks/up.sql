CREATE SEQUENCE bookmarks_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1
;

CREATE TABLE bookmarks (
  id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('bookmarks_id_seq'),
  uuid UUID NOT NULL DEFAULT uuid_generate_v4(),
  url CHARACTER VARYING(2048) NOT NULL,
  title CHARACTER VARYING(256) NULL,
  description TEXT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc'),
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc')
);

ALTER SEQUENCE bookmarks_id_seq OWNED BY bookmarks.id;

CREATE UNIQUE INDEX bookmarks_uuid_idx ON bookmarks(uuid);
