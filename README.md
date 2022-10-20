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
## Contents

The main logic of the source file organization is inside `paper.tex` and the bibliography is inside `paper.bib`.
However, the entry points for build pipelines are in `out_draft.tex` and `out_final.tex` respectively.
If you're using an external IDE for building the source files, set either of these sources as the entry point of the compilation.

The rest of the source files are named so that it's easier to navigate through them in overleaf.
Each group of files are:
- `conf_<name>.tex` - any configuration / latex definitions you might need
- `fig_<name>.tex` - figure generation source files
- `metadata_<name>.tex` - metadata relating to the publication such as authors, journal article number, rights info etc.
- `sec_<name>.tex` - individual sections that make up the document
- `tab_<name>.tex` - table generation source files

Additionally, the original manual for ACM template usage document is kept in this repo named `_acmguide.pdf` and `_template_guide.pdf`.
If you need information regarding specifically the `acmart` class, please refer to these documents.
