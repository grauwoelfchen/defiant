diesel::table! {
    use diesel::sql_types::*;

    bookmarks (id) {
        id -> Int8,
        uuid -> Uuid,
        #[max_length = 2048]
        url -> Varchar,
        #[max_length = 256]
        title -> Nullable<Varchar>,
        description -> Nullable<Text>,
        created_at -> Timestamp,
        updated_at -> Timestamp,
    }
}
