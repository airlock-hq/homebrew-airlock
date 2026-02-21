cask "airlock" do
  version "0.1.9"
  sha256 "738741b1c6802df2f70b13cc7217f0c2c4349973a8f8e984f59938e2eba48c48"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.9/Airlock-0.1.9-universal.dmg"
  name "Airlock"
  desc "Vibe code in. Clean PR out. Local CI built for high-velocity agentic engineering."
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
    system_command "#{appdir}/Airlock.app/Contents/MacOS/airlock",
                  args: ["daemon", "stop"],
                  must_succeed: false
    system_command "/bin/launchctl",
                  args: ["unload", "-w", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")],
                  must_succeed: false
  end

  uninstall delete: "~/Library/LaunchAgents/dev.airlock.daemon.plist"

  zap trash: "~/.airlock"
end
