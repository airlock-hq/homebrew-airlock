cask "airlock" do
  version "0.1.28"
  sha256 "e33ecd319e428025bae520b8e33c0c0adfb45f2151db5996d0bac814518e99d6"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.28/Airlock-0.1.28-universal.dmg"
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
