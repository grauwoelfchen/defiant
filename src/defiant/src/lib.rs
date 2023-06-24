use std::fs;
use std::path::PathBuf;

use serde::Deserialize;

const PKG_NAME: &str = env!("CARGO_PKG_NAME");

#[derive(Debug, Deserialize)]
pub struct Config {
    pub database_file: Option<String>,
}

// returns the default config directory as `PathBuf`.
fn get_default_config_dir() -> PathBuf {
    // get $HOME at the runtime
    let home_dir = home::home_dir().unwrap();
    home_dir.join(".config").join(PKG_NAME)
}

// returns the default config file path as a `String`.
fn get_default_config_file() -> String {
    let config_dir = get_default_config_dir();
    config_dir
        .join("config.toml")
        .into_os_string()
        .into_string()
        .unwrap()
}

// returns the default database file path as a `String`.
fn get_default_database_file() -> String {
    let config_dir = get_default_config_dir();
    config_dir
        .join(format!("{0}.db", PKG_NAME))
        .into_os_string()
        .into_string()
        .unwrap()
}

// resolves $HOME directory (~) at the runtime.
fn expand_tilde(path: &str) -> String {
    if path.starts_with('~') {
        let home_dir = home::home_dir().unwrap();
        return format!(
            "{0}/{1}",
            home_dir.into_os_string().into_string().unwrap(),
            path.strip_prefix("~/").unwrap()
        );
    }
    path.to_string()
}

/// Returns a config object.
/// ```toml
/// database_file = "/path/to/file.db"
/// ```
pub fn get_config(config_file: &str) -> Config {
    let mut file = config_file.to_string();
    if file.is_empty() {
        // TODO: create if the file does not exist yet
        file = get_default_config_file();
    }
    let content = fs::read_to_string(&file).expect("couldn't read the file");
    let mut config: Config =
        toml::from_str(&content).expect("couldn't parse the content");

    let database_file = match config.database_file {
        Some(ref s) => expand_tilde(s),
        None => get_default_database_file(),
    };
    config.database_file = Some(database_file);
    config
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_get_default_config_dir() {
        let config_dir = get_default_config_dir();
        let home_dir = home::home_dir().unwrap();

        let expected = PathBuf::from(format!(
            "{0}/.config/{1}",
            home_dir.to_str().unwrap(),
            PKG_NAME
        ));
        assert_eq!(config_dir, expected);
    }

    #[test]
    fn test_get_default_config_file() {
        let config_file = get_default_config_file();

        let expected = format!("{0}/.config/defiant/config.toml", env!("HOME"));
        assert_eq!(config_file, expected);
    }

    #[test]
    fn test_get_default_database_file() {
        let database_file = get_default_database_file();

        let expected = format!("{0}/.config/defiant/defiant.db", env!("HOME"));
        assert_eq!(database_file, expected);
    }

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
        let home_dir = home::home_dir().unwrap();

        let expected = Some(format!(
            "{0}/.config/{1}/{1}.db",
            home_dir.to_str().unwrap(),
            PKG_NAME
        ));

        let config = get_config("test/data/blank.toml");
        assert_eq!(config.database_file, expected);

        let config = get_config("test/data/sample.toml");
        assert_eq!(config.database_file, expected);
    }
}
