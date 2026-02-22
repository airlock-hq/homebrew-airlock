cask "airlock" do
  version "0.1.22"
  sha256 "3a42169bdb63a94a6c8fd3262a519907e61db6b4278c3d0b7216006ee6f8ca4a"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.22/Airlock-0.1.22-universal.dmg"
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
    # Clear any stale service registration before bootstrapping
    system_command "/bin/launchctl",
                  args: ["bootout", "gui/#{Process.uid}/dev.airlock.daemon"],
                  must_succeed: false
    system_command "/bin/launchctl",
                  args: ["bootstrap", "gui/#{Process.uid}", File.expand_path("~/Library/LaunchAgents/dev.airlock.daemon.plist")],
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
