# Starter Templates

The `craftcms-starter` comes with an opinionated base template system that is designed to get you up and running quickly. You can use the templates as-is, or you can customize them to your project needs.

The templates uses the Twig tem­plat­ing lan­guage, and as such it should not be used for com­pli­cat­ed busi­ness or inten­sive calculations.

Not that it can’t han­dle either (it can) but rather that it shouldn’t.

If you’re unclear as to why, read about why Twig was cre­at­ed to begin with in the [Tem­plat­ing Engines in PHP article](http://fabien.potencier.org/templating-engines-in-php.html).

## Introduction

Every project is dif­fer­ent, but some underly­ing prin­ci­ples are the same. So here’s what we want out of a base tem­plat­ing system:

1. The abil­i­ty to use it unmod­i­fied on a wide vari­ety of projects
2. One tem­plate that can be used both as a web page, and as pop­up modals via AJAX / XHR
3. Imple­ment core fea­tures for us, with­out restrict­ing me in terms of flexibility

Throughout this doc­u­men­ta­tion, we’ll refer to templates as a **Project** or **Boilerplate** template:

A **Project** template may vary from project to project.

A **Boilerplate** template is the same for every project.

## Structure

The tem­plat­ing sys­tem is built on the fol­low­ing struc­ture:

```bash
├── _base
│   ├── _base_html_layout.twig
│   ├── _base_web_layout.twig
│   ├── _body_js.twig
│   ├── _head_js.twig
│   ├── _head_meta.twig
│   └── _tab_handler.twig
├── _components
│   ├── _heading.twig
│   ├── _img.twig
│   ├── _pageHeader.twig
│   ├── _useSprite.twig
│   └── _contentBlocks
│       ├── index.twig
│       ├── _richText.twig
│       └── _picture.twig
├── _layouts
│   ├── _global_variables.twig
│   ├── _naked_layout.twig
│   └── _base_page_layout.twig
├── _pages
│   ├── _page.twig
│   ├── _default_page.twig
│   └── _home.twig
├── _partials
│   ├── _site_header.twig
│   └── _site_footer.twig
├── index.twig
└── page.twig
```

I will explain each of these files in detail below, following Twig's processing order. You can learn more about [Twig Processing Order & Scope here](https://nystudio107.com/blog/twig-processing-order-and-scope).

### \_layouts/\_global_variables.twig (Project)

Due to Twig’s Pro­cess­ing Order & Scope, if we want to have glob­al vari­ables that are always avail­able in all of our tem­plates, they need to be defined in the root tem­plate that all oth­ers extends from.

Since these glob­als can vary from project to project, they are not part of the boil­er­plate, but they are required for the setup.

The `_global_variables.twig` tem­plate has the fol­low­ing blocks that can be over­rid­den by its children:

`htmlPage` —  a block that encom­pass­es the entire ren­dered HTML page

### \_base/\_base_web_layout.twig (Boilerplate)
