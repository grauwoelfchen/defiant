BEGIN;

ALTER TABLE bookmarks
  -- bookmarks_user_id_fkey
  ADD COLUMN user_id BIGINT REFERENCES users (id) MATCH FULL NOT NULL
  -- data rotation (https://wiki.postgresql.org/wiki/Alter_column_position)
, ADD COLUMN tmp_uuid UUID NOT NULL DEFAULT uuid_generate_v4()
, ADD COLUMN tmp_url CHARACTER VARYING(2048) NOT NULL
, ADD COLUMN tmp_title CHARACTER VARYING(256) NULL
, ADD COLUMN tmp_description TEXT NULL
, ADD COLUMN tmp_created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc')
, ADD COLUMN tmp_updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc')
;

UPDATE bookmarks SET
  tmp_uuid=uuid
, tmp_url=url
, tmp_title=title
, tmp_description=description
, tmp_created_at=created_at
, tmp_updated_at=updated_at
;

ALTER TABLE bookmarks
  DROP COLUMN uuid CASCADE
, DROP COLUMN url CASCADE
, DROP COLUMN title CASCADE
, DROP COLUMN description CASCADE
, DROP COLUMN created_at CASCADE
, DROP COLUMN updated_at CASCADE
;

ALTER TABLE bookmarks RENAME COLUMN tmp_uuid to uuid;
ALTER TABLE bookmarks RENAME COLUMN tmp_url to url;
ALTER TABLE bookmarks RENAME COLUMN tmp_title to title;
ALTER TABLE bookmarks RENAME COLUMN tmp_description to description;
ALTER TABLE bookmarks RENAME COLUMN tmp_created_at to created_at;
ALTER TABLE bookmarks RENAME COLUMN tmp_updated_at to updated_at;

-- recreate missing one
CREATE UNIQUE INDEX bookmarks_uuid_idx ON bookmarks(uuid);

CREATE INDEX bookmarks_user_id_idx ON bookmarks(user_id);
