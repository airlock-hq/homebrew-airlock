cask "airlock" do
  version "0.1.5"
  sha256 "99630d2eda6a14d58a257d2b05f278fb639adc739451ef6bb53e85ab9529733d"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.5/Airlock-0.1.5-universal.dmg"
  name "Airlock"
  desc "Local-first Git proxy that transforms AI-generated code into clean PRs"
  homepage "https://github.com/airlock-hq/airlock"

  depends_on macos: ">= :ventura"

  app "Airlock.app"
  binary "#{appdir}/Airlock.app/Contents/MacOS/airlock"
  binary "#{appdir}/Airlock.app/Contents/MacOS/airlockd"

  postflight do
    system_command "/usr/bin/xattr",
                  args: ["-cr", "#{appdir}/Airlock.app"]
    system_command "#{appdir}/Airlock.app/Contents/MacOS/airlock",
                  args: ["daemon", "install"]
    system_command "/bin/launchctl",
                  args: ["load", "-w", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")]
  end

  uninstall_preflight do
    system_command "/bin/launchctl",
                  args: ["unload", "-w", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")],
                  must_succeed: false
  end

  uninstall delete: "~/Library/LaunchAgents/dev.airlock.daemon.plist"

  zap trash: "~/.airlock"
end
