BEGIN;

ALTER TABLE bookmarks
  -- bookmarks_user_id_fkey
  ADD COLUMN user_id BIGINT REFERENCES users (id) MATCH FULL NOT NULL
  -- data rotation (https://wiki.postgresql.org/wiki/Alter_column_position)
, ADD COLUMN _uuid UUID NOT NULL DEFAULT uuid_generate_v4()
, ADD COLUMN _url CHARACTER VARYING(2048) NOT NULL
, ADD COLUMN _title CHARACTER VARYING(256) NULL
, ADD COLUMN _description TEXT NULL
, ADD COLUMN _created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc')
, ADD COLUMN _updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
    DEFAULT (now() AT TIME ZONE 'utc')
;

UPDATE bookmarks SET
  _uuid=uuid
, _url=url
, _title=title
, _description=description
, _created_at=created_at
, _updated_at=updated_at
;

ALTER TABLE bookmarks
  DROP COLUMN uuid CASCADE
, DROP COLUMN url CASCADE
, DROP COLUMN title CASCADE
, DROP COLUMN description CASCADE
, DROP COLUMN created_at CASCADE
, DROP COLUMN updated_at CASCADE
;

ALTER TABLE bookmarks RENAME COLUMN _uuid to uuid;
ALTER TABLE bookmarks RENAME COLUMN _url to url;
ALTER TABLE bookmarks RENAME COLUMN _title to title;
ALTER TABLE bookmarks RENAME COLUMN _description to description;
ALTER TABLE bookmarks RENAME COLUMN _created_at to created_at;
ALTER TABLE bookmarks RENAME COLUMN _updated_at to updated_at;

-- recreate missing one
CREATE UNIQUE INDEX bookmarks_uuid_idx ON bookmarks(uuid);

CREATE INDEX bookmarks_user_id_idx ON bookmarks(user_id);
