# QtDeployWin

*Win at deploying your Qt application for Windows.*

This is a tiny command-line utility that takes a Qt application executable file built for Windows and produces a directory with a complete set of dependencies required to run the executable on other machines.

It is effectively a thin wrapper around Qt's `windeployqt` that tries to guess and set some environment variables for you and does some other useful actions that you don't need to do manually.

## Installation

Install the command line utility:

    $ gem install qt-deploy-win

Or to use it in your project just add this to `Gemfile`

    gem 'qt-deploy-win'

And then execute:

    $ bundle

## Usage

Pass you freshly built app executable path and an output dir (will be cleared!).

    qt-deploy-win path/to/my-qt-app.exe output-dir/

**Warning!** Output dir is cleared every time you run the utility, so use carefully and do not lose your files!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
