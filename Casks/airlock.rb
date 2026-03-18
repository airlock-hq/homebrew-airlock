cask "airlock" do
  version "0.1.68"
  sha256 "cba508cfbf5ab486cf39743ac24ab690e0b4a2253beadc44a23a2c208e59b05c"

  url "https://github.com/airlock-hq/airlock/releases/download/airlock-v0.1.68/Airlock-0.1.68-universal.dmg"
  name "Airlock"
  desc "All slop must die. Airlock is where every git push turns into a slop-free PR."
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
