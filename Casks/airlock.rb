cask "airlock" do
  version "0.1.36"
  sha256 "26f14e08466bcda3067eb3ea8c68ba9b710452a8ce75a96a369feba30b4b68ef"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.36/Airlock-0.1.36-universal.dmg"
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
