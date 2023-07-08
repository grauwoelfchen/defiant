#[macro_use]
extern crate rocket;

use rocket::{Route, State};
use rocket::http::Status;
use rocket::serde::json::json;
use defiant::{get_config, Config};

use defiant_web::response::Response;

#[get("/")]
fn index() -> Response {
    let res = Response::new();
    res.status(Status::Ok).format(json!({"data": []}))
}

#[allow(dead_code)]
#[get("/health")]
fn check(_state: &State<Config>) -> Response {
    let res = Response::new();
    res.status(Status::NoContent)
}

fn get_routes() -> Vec<Route> {
    routes![index, check,]
}

#[launch]
fn server() -> _ {
    // TODO: config
    let config = get_config("");
    let routes = get_routes();
    rocket::build().manage(config).mount("/", routes)
}
