# Polito Comm Systems Client

- Based on: [flutter navigation & routing sample app](https://flutter.github.io/samples/navigation_and_routing.html)
- More Examples: [flutter sample apps](https://flutter.github.io/samples/#)

## Current Procedure for testing the build version

- run `flutter build web  --release --web-renderer html`
- replace problematic lines in `build/web/index.html` file as explained [here](https://github.com/linomp/polito-comm-systems-client/issues/11)
- commit and push (does not have to be `master`, can also be another branch)
- on digital ocean droplet console, do `git pull` (remember to switch branches if what you want to test is not in `master`)
- test the app at http://apps.xmp.systems:8080


  _Note_: There's no need anymore for changing the "./" in index.html.  Leave it as "/".
