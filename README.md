This is just the official Python 3.9-buster image tag with some personal addons for a better dev environment. This is a heavy image not meant for production.

This adds to the official image:

- IPython 3
- vim
- a custom bashrc
- locales
- virtualenv

Using **virtualenv** to have NPM-like environments definitions. To create an environment, run **virtualenv name_of_env**, and to activate it, **. name_of_env/bin/activate**. This way PIP installed packages are local to the source tree. Installed packages should be properly installed in global PIP in production images.
