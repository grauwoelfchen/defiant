#[macro_use]
extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "FIXME"
}

#[launch]
fn server() -> _ {
    rocket::build().mount("/", routes![index])
}
