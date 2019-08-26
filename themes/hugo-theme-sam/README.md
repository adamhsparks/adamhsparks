<h1><a href="https://vickylai.com/call-me-sam/" target="_blank" rel="noopener">Call me Sam: a theme for Hugo</a></h1>

![Main page screenshot](https://github.com/vickylai/hugo-theme-sam/blob/master/images/screenshot.png)

Sam is a Simple and Minimalist theme for Hugo. It lets you categorize and showcase your content the way you want to.

Focused on content and typography, the stylized index page is really just a list of navigation links that you can set in your `config.toml`. This versatile design is limited only by your imagination, as you can make it say anything you like. Here are some ideas.

![Index page iterations.](https://github.com/vickylai/hugo-theme-sam/blob/master/images/ideas.png)

# Features:

- Showcase content
    - Content-focused page templates for list pages, single pages, and posts
    - A responsive CSS grid gallery page that renders from a folder of images
- Customize
    - Custom navigation menu set via `config.toml`
    - Custom footer text
- Developer-approved
    - Syntax highlighting
    - Share-ready metadata set via `config.toml` (OpenGraph and Twitter Cards integration)
    - Easy-to-navigate pug and Sass files included


# Quick start

## 1. Get the theme

Run from the root of your Hugo site:
```sh
$ git clone https://github.com/vickylai/hugo-theme-sam.git themes/sam
```

Alternatively you can include this repository as a [git submodule](https://git-scm.com/book/de/v1/Git-Tools-Submodule). This makes it easier to update this theme if you have your Hugo site in git as well. For this you need to run:

```sh
$ git submodule add https://github.com/vickylai/hugo-theme-sam.git themes/sam
```

## 2. Configure your site

From the exampleSite, copy `config.toml` to the root folder of your Hugo site and change the fields as you like. There are helpful hints in the file.

## 3. Create pages

Run:
```sh
$ hugo new page.md
```
Where `page` can be anything you like. A contact page, a bio, dates for your upcoming world tour... Anything!

## 4. Design your main menu and index page

In `config.toml`, customize the entries for `[[params.mainMenu]]` however you like. You can have as many or as few entries as you like. You can even include external links.

This list comprises the index page and part of the navigation menu at the bottom of single content pages. Here's an example:

```
[[params.mainMenu]]
    link = "/photography"
    text = "photography"

[[params.mainMenu]]
    link = "/posts"
    text = "writing"

[[params.mainMenu]]
    link = "/about"
    text = "who dis?"
```

## Preview your site locally

Use Hugo's built-in server to see your site in action as you make changes.

```sh
$ hugo serve -t sam
```

Visit `localhost:1313` in your browser to see a live preview of your site.

## Posts

To create a new post, run:
```sh
$ hugo new posts/your-post-title.md
```

# Editing the theme

All the theme's `pug` and `sass` files are included. You can compile these to HTML and CSS respectively using the npm scripts included in `package.json`.

Prerequisites:
* Node.js and npm: https://www.npmjs.com/get-npm

To install all dependencies:

```sh
$ npm install
```

Available commands are:

* `npm run build:pug` compiles pug files to HTML
* `npm run build:sass` compiles Sass files to compressed CSS
* `npm run autoprefixer` autoprefixes the compiled CSS
* `npm run build` does all the above
* `npm run watch` watches Sass files for changes and automatically recompiles and autoprefixes the CSS

# Contributing

Pull requests for bug fixes and enhancements are welcome.

__Thank you to:__ @paskal, @crownsedge, @jazzi, @hakamadare, @mfg92, and @Hanzei!

# License
Copyright (C) 2018 Vicky Lai

Licensed under [AGPL-3.0](https://github.com/vickylai/hugo-theme-sam/blob/master/LICENSE)
