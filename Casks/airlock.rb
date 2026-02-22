cask "airlock" do
  version "0.1.17"
  sha256 "3db3dc9b3ba051690c05c0a4a78930a8b3b9ed24c824f5651a85b9c76149cc1d"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.17/Airlock-0.1.17-universal.dmg"
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
                  args: ["bootstrap", "gui/#{Process.uid}", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")]
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
