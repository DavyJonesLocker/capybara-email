## Unreleased

  * Avoid modifying frozen strings ([yuri-zubov][yuri-zubov])
  * Define `#respond_to_missing?` on `Capybara::Node::Email`
    ([tylerhunt][tylerhunt])

## 3.0.0

  * Update for Capybara 3 compatibility

## 2.4.0

  * Updated Capybara

## 2.3.0

  * Adds `Capybara::Node::Email#header` and `Capybara::Node::Email#headers` for
    retrieving optional headers set on an email.
  * Corrects `inspect` of `Capybara::Node::Email`
  * Delegate all missing methods in `Capybara::Node::Email` to `base.email`

[tylerhunt]: https://github.com/tylerhunt
[yuri-zubov]: https://github.com/yuri-zubov
