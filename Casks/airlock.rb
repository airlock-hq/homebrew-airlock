cask "airlock" do
  version "0.1.42"
  sha256 "63d83d57e010fe2ba6e1cc2f9df3ce3c9010df0b79054d4e5ac2da8170ce05ec"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.42/Airlock-0.1.42-universal.dmg"
  name "Airlock"
  desc "Vibe code in. Clean PR out. Self-healing local CI for high-velocity agentic engineering."
  homepage "https://github.com/airlock-hq/airlock"

  depends_on macos: ">= :ventura"

  app "Airlock.app"
  binary "#{appdir}/Airlock.app/Contents/MacOS/airlock"
  binary "#{appdir}/Airlock.app/Contents/MacOS/airlockd"

  postflight do
    system_command "/usr/bin/xattr",
                  args: ["-cr", "#{appdir}/Airlock.app"]
    system_command "#{appdir}/Airlock.app/Contents/MacOS/airlock",
                  args: ["daemon", "install"],
                  must_succeed: false
  end

  uninstall_preflight do
    system_command "#{appdir}/Airlock.app/Contents/MacOS/airlock",
                  args: ["daemon", "stop"],
                  must_succeed: false
    system_command "/bin/rm",
                  args: ["-f", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")],
                  must_succeed: false
  end

  zap trash: "~/.airlock"
end
