use clap::Parser;
use defiant::get_config;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Path to the config file
    #[arg(short, long)]
    config: String,
}

fn main() {
    let args = Args::parse();
    let config_file = args.config;
    let config = get_config(&config_file);

    // FIXME
    println!("{}", config.database_file);
}
