// @generated automatically by Diesel CLI.

diesel::table! {
    use diesel::sql_types::*;

    bookmarks (id) {
        id -> Int8,
        user_id -> Int8,
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

diesel::table! {
    use diesel::sql_types::*;

    users (id) {
        id -> Int8,
        created_at -> Timestamp,
        updated_at -> Timestamp,
    }
}

diesel::joinable!(bookmarks -> users (user_id));

diesel::allow_tables_to_appear_in_same_query!(
    bookmarks,
    users,
);
