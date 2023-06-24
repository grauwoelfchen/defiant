use std::fs;

use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub database_file: String,
}

const DEFAULT_DATABASE_FILE: &str = "~/.config/defiant/defiant.db";

/// Returns a config object.
/// ```toml
/// database_file = "/path/to/file.db"
/// ```
pub fn get_config(config_file: &str) -> Config {
    let content =
        fs::read_to_string(config_file).expect("couldn't read the file");
    let mut config: Config =
        toml::from_str(&content).expect("couldn't parse the content");

    if config.database_file.is_empty() {
        config.database_file = DEFAULT_DATABASE_FILE.to_string();
    }
    config
}

#[cfg(test)]
mod test {
    use super::*;

    // FIXME
    #[test]
    #[should_panic(expected = "couldn't read the file")]
    fn test_get_config_with_missing_file() {
        let _ = get_config("/path/to/none-existing-file");
    }

    // FIXME
    #[test]
    #[should_panic(expected = "couldn't parse the content")]
    fn test_get_config_with_invalid_file() {
        let _ = get_config("test/data/invalid.toml");
    }

    #[test]
    fn test_get_config() {
        let config = get_config("test/data/sample.toml");
        assert_eq!(config.database_file, DEFAULT_DATABASE_FILE);
    }
}
