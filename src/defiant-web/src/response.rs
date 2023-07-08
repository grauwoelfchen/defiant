use std::io::Cursor;

use rocket::response::{Response as RawResponse, Responder};
use rocket::request::Request;
use rocket::http::Status;
use rocket::serde::json::{json, Value};

#[derive(Debug, PartialEq)]
pub struct Response {
    pub status: Status,
    pub data: Value,
}

impl Default for Response {
    fn default() -> Self {
        Self {
            status: Status::Ok,
            data: json!(null),
        }
    }
}

impl Response {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn status(mut self, status: Status) -> Self {
        self.status = status;
        self
    }

    pub fn format(mut self, data: Value) -> Self {
        self.data = data;
        self
    }
}

impl<'r> Responder<'r, 'r> for Response {
    #[allow(dead_code)]
    fn respond_to(self, _req: &Request) -> Result<RawResponse<'r>, Status> {
        let mut builder = RawResponse::build();

        if self.status != Status::NoContent {
            let body = self.data.to_string();
            builder.sized_body(body.len(), Cursor::new(body));
        }
        builder.status(self.status);
        builder.ok()
    }
}

#[cfg(test)]
mod test {
    use super::*;

    use rocket::http::Method;
    use rocket::local::asynchronous::Client;
    use rocket::tokio;

    #[test]
    fn test_response_new_returns_default() {
        let new = Response::new();
        let default: Response = Default::default();
        assert_eq!(new, default);
    }

    #[test]
    fn test_response_methods_chain() {
        let res = Response::new().status(Status::Ok).format(json!(null));
        assert_eq!(res.status, Status::Ok);
        assert_eq!(res.data, json!(null));
    }

    #[tokio::test]
    async fn test_response_respond_to_with_default() {
        let res = Response::new();

        let client = Client::untracked(rocket::build())
            .await
            .expect("valid rocket");
        let local = client.req(Method::Get, "/");
        let req = local.inner();

        let mut raw = res.respond_to(req).ok().unwrap();
        assert_eq!(raw.status(), Status::Ok);

        // null (json)
        let body_size = raw.body().preset_size().unwrap();
        assert_eq!(body_size, 4);
        let body = raw.body_mut().to_string().await.unwrap();
        assert_eq!(body, "null".to_string());
    }

    #[tokio::test]
    async fn test_response_respond_to_with_no_content() {
        let res = Response::new().status(Status::NoContent);

        let client = Client::untracked(rocket::build())
            .await
            .expect("valid rocket");
        let local = client.req(Method::Get, "/");
        let req = local.inner();

        let mut raw = res.respond_to(req).ok().unwrap();
        assert_eq!(raw.status(), Status::NoContent);

        // unset
        let body_size = raw.body().preset_size().unwrap();
        assert_eq!(body_size, 0);
        let body = raw.body_mut().to_string().await.unwrap();
        assert_eq!(body, "".to_string());
    }
}
