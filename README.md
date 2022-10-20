# ACM TOG / SIGGRAPH Template

This template was adapted from the official ACM template on [overleaf](https://www.overleaf.com/latex/templates/acm-conference-proceedings-primary-article-template/wbvnghjbzwpc), as well as Li-Yi Wei's [research templates](https://github.com/1iyiwei/research-templates).

The modular organization of source files make it easy to keep your manuscript tidy, and also quick to iterate between generating "draft" and "final" versions of the output documents.

## Usage

As a pre-requisite make sure to have `make`, `texlive` and `ghostscript` installed on your system.

To build the project in "draft" or "final" mode, run
```shell
make draft
```
or
```shell
make final
```
respectively.

Apart from the expected Latex intermediate files, the build pipeline also separates out the supplementary material section from the manuscript document, and compresses both documents using `ghostscript`.

To clean-up the generated files, run
```shell
make clean
```
