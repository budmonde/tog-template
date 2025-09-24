# ACM TOG / SIGGRAPH Template

This LATEX template was developed to (1) streamline collaborative manuscript editing and (2) automate many processes that manuscripts undergo throughout the publication process of academic papers.
Many ideas, features, and aspects in this template were adapted from my previous collaborators and mentors such as Qi Sun, Li-Yi Wei and Jane Hoffswell.
Here are upstream versions of this template from [the official ACM tempalte on overleaf](https://www.overleaf.com/latex/templates/acm-conference-proceedings-primary-article-template/wbvnghjbzwpc), and [Li-Yi Wei's research templates](https://github.com/1iyiwei/research-templates).

## Pre-requisites

The Makefile assumes the usage of `pdflatex`, so please make sure to install the `texlive`, `texlive-latex-extra`, `texlive-fonts-recommended`, `texlive-science`, and `texlive-xstring` packages.
Additionally, `ghostscript` is used for post-compilation PDF document processing such as to separate the document into separate files for the manuscript and supplementary materials.
See more details on this in `HOWTO.pdf`.

## Usage

### Makefile

The LATEX compilation is managed by a `Makefile`. The `Makefile` features multiple build targets meant for various versions of the document, such as `internal` for sharing between collaborators, and `submission` for anonymous submissions.
These targets are built by running make `<target_name>` (e.g., `make internal`).
See `HOWTO.pdf` for details on the various build targets.

TLDR; run

```shell
make internal
```
or
```shell
make submission
```

To clean-up generated files, run
```shell
make clean
```

### TeXstudio

You can import the `main.tex` file into your TeXstudio window, and specify it as the root file for compilation.
To change the compile target, edit the symlink of `main.tex` to point to the desired target.

### Overleaf

You can use this template with overleaf by specifying the main document to the desired compilation target inside `targets/` directory.
This setting can be found under `Menu > Main document`.

### VS Code + LaTeX Workshop
To use the template in VS Code, please use the LaTeX Workshop extension (`latex-workshop`).
The compilation should automatically detect the `main.tex` file as the root file of the project.

## Further Details

For further details on the organization of this repository, see `HOWTO.pdf`.
