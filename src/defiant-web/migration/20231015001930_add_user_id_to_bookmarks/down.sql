BEGIN;

DROP INDEX IF EXISTS bookmarks_user_id_idx;

ALTER TABLE bookmarks DROP CONSTRAINT IF EXISTS bookmarks_user_id_fkey RESTRICT;
ALTER TABLE bookmarks DROP COLUMN IF EXISTS user_id RESTRICT;
