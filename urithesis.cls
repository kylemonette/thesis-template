%% urithesis.cls
%% Version 3.0 (June 2026)
%% Copyright 2004, 2005, 2006, 2016, 2024, University of Rhode Island
%% Original Author: Timothy Toolan, Department of Electrical Engineering
%%
%% Modernized: 2026 by Kyle Monette, kylemonette.github.io
%%
%% See http://www.ele.uri.edu/info/thesis/guide for the latest
%% info, including usage and examples.
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%        University of Rhode Island thesis class for LaTeX.
%
% This LaTeX class is used to create theses and dissertations which
% conform to the Graduate School guidelines at the University of Rhode
% Island. It generates all of the preliminary pages including the title
% page, approval page, table of contents, list of figures, and list of
% tables. It generates the required bibliography, as well as lists of
% references. It also sets margins, spacing, and other format elements
% as required.
%
% The primary style manual used is Kate Turabian's "Manual for Writers
% of Papers, Theses, and Dissertations," and the bibliography and
% references use the IEEE format.
%
%
% General Options:
%
%   phd, masters      PhD dissertation or masters thesis (default: masters)
%
%   10pt, 11pt, 12pt  Font size (default: 12pt)
%
%   oneref            Single list of references after the last chapter,
%                     instead of per-chapter reference lists (default).
%
%   chapterref        Per-chapter reference lists instead of a single list.
%                     After the first pdflatex pass, run the generated
%                     genbib.sh script for the complete compile sequence.
%
%   bibliography      Add a combined alphabetical BIBLIOGRAPHY section at the
%                     end of the document (after the numbered reference lists).
%                     Useful with \nocite{*} to include works consulted but not
%                     cited.  Off by default.
%
%   manuscript        Each chapter is called "Manuscript" instead of "Chapter".
%
%   3committee,       Number of core committee members on the approval page
%   4committee,       (not counting the Dean). Default: 3committee.
%   5committee
%
%   sequential,       Whether figure/table/equation numbering resets each
%   nonsequential     chapter (nonsequential) or runs throughout (sequential).
%                     Default: sequential.
%
%   topnum, bottomnum Page numbers top-right or bottom-center.
%                     Default: bottomnum.
%
%   aparefs           Author-year citations like (Toolan, 2006) instead of [1].
%
%   electronic,       Approval page with or without signature lines.
%   hardcopy          Default: hardcopy.
%
%
% Writing/Draft Options (not for final submission):
%
%   draft             Show overfull box markers; figure filenames only.
%
%   draftbox          Like draft but figures are displayed.
%
%   simpleref         Single reference list at document end; only one BibTeX
%                     run needed.
%
%   noprelim          Suppress all preliminary pages (title, TOC, etc.).
%
%   nobib             Suppress bibliography and reference lists entirely.
%
%
% Examples:
%
%   \documentclass[oneref]{urithesis}
%   \documentclass[phd]{urithesis}
%   \documentclass[phd,manuscript,4committee,topnum]{urithesis}
%
%
% Notes:
%
%   You will need uriref.bst, uribib.bst, and uriapa.bst for the
%   bibliography and reference lists.
%
%   The department on the title page defaults to "ELECTRICAL ENGINEERING"
%   but can be changed with \dept{My Department} in the main .tex file.
%
%   The acknowledgements, preface, and dedication sections are optional;
%   the abstract section is required.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{urithesis}[2026/06/29 v3.0 University of Rhode Island thesis format]

%----------------------------------------------------------------------
% Required packages loaded early so options can use them
%----------------------------------------------------------------------
\RequirePackage{etoolbox}
\RequirePackage{ifthen}

%----------------------------------------------------------------------
% Option declarations
%----------------------------------------------------------------------

\newbool{@wantchapterref}  \boolfalse{@wantchapterref}
\DeclareOption{chapterref}{\booltrue{@wantchapterref}}
\DeclareOption{oneref}{\boolfalse{@wantchapterref}}

\newbool{@wantapalike}  \boolfalse{@wantapalike}
\DeclareOption{aparefs}{\booltrue{@wantapalike}}

\newbool{@wantmanuscript}  \boolfalse{@wantmanuscript}
\DeclareOption{manuscript}{\booltrue{@wantmanuscript}}
\DeclareOption{standard}{\boolfalse{@wantmanuscript}}

\newbool{@simpleref}  \boolfalse{@simpleref}
\DeclareOption{simpleref}{\booltrue{@simpleref}\boolfalse{@wantchapterref}}

\newbool{@masters}  \booltrue{@masters}
\DeclareOption{phd}{\boolfalse{@masters}}
\DeclareOption{masters}{\booltrue{@masters}}

\newbool{@fourcommittee}  \boolfalse{@fourcommittee}
\newbool{@fivecommittee}  \boolfalse{@fivecommittee}
\DeclareOption{3committee}{\boolfalse{@fourcommittee}\boolfalse{@fivecommittee}}
\DeclareOption{4committee}{\booltrue{@fourcommittee}\boolfalse{@fivecommittee}}
\DeclareOption{5committee}{\booltrue{@fourcommittee}\booltrue{@fivecommittee}}

\newbool{@topnumbers}  \boolfalse{@topnumbers}
\DeclareOption{topnum}{\booltrue{@topnumbers}}
\DeclareOption{bottomnum}{\boolfalse{@topnumbers}}

\newbool{@electronic}  \boolfalse{@electronic}
\DeclareOption{hardcopy}{\boolfalse{@electronic}}
\DeclareOption{electronic}{\booltrue{@electronic}}

\newbool{@sequential}  \booltrue{@sequential}
\DeclareOption{nonsequential}{\boolfalse{@sequential}}
\DeclareOption{sequential}{\booltrue{@sequential}}

\newbool{@noprelim}  \boolfalse{@noprelim}
\DeclareOption{noprelim}{\booltrue{@noprelim}}
\DeclareOption{prelim}{\boolfalse{@noprelim}}

\newbool{@nobib}  \boolfalse{@nobib}
\DeclareOption{nobib}{\booltrue{@nobib}}

% bibliography — emit a combined alphabetical BIBLIOGRAPHY section at the end
% (in addition to the numbered reference lists).  Useful when you want to include
% works consulted but not cited via \nocite{*}.  Off by default.
\newbool{@wantbiblio}  \boolfalse{@wantbiblio}
\DeclareOption{bibliography}{\booltrue{@wantbiblio}}

\newbool{@draftbox}  \boolfalse{@draftbox}
\DeclareOption{draftbox}{\booltrue{@draftbox}}

% Font-size option forwarded to report class
\def\@optptsize{12pt}
\DeclareOption{10pt}{\def\@optptsize{10pt}}
\DeclareOption{11pt}{\def\@optptsize{11pt}}
\DeclareOption{12pt}{\def\@optptsize{12pt}}

\DeclareOption{draft}{\PassOptionsToClass{draft}{report}}
\DeclareOption{final}{\PassOptionsToClass{final}{report}}

\ProcessOptions\relax

\LoadClass[letterpaper,oneside,titlepage,onecolumn,openany,\@optptsize]{report}

%----------------------------------------------------------------------
% Post-option setup
%----------------------------------------------------------------------

\ifbool{@draftbox}{\setlength\overfullrule{5pt}}{}

% APA citation formatting
\ifbool{@wantapalike}{%
  \def\@refbstfile{uriapa}%
  \def\@cite#1#2{(#1\if@tempswa , #2\fi)}%
  \def\citepunct{; }%
  \def\@biblabel#1{}%
}{%
  \def\@refbstfile{uriref}%
}

%----------------------------------------------------------------------
% Packages required by the class body
%----------------------------------------------------------------------
\RequirePackage{url}
\RequirePackage{xparse}

%----------------------------------------------------------------------
% User-facing configuration commands
%----------------------------------------------------------------------

\def\dept#1{\gdef\@dept{#1}}
\def\copyrightyear#1{\gdef\@copyrightyear{#1}}
\def\reffile#1{\gdef\@reffile{#1}}
\def\abstract#1{\gdef\@abstract{#1}}
\def\acknowledgements#1{\gdef\@acknowledgements{#1}}
\def\preface#1{\gdef\@preface{#1}}
\def\dedication#1{\gdef\@dedication{#1}}
\def\titledisclaimer#1{\gdef\@titledisclaimer{#1}}

% Accumulate up to five committee signatures
\def\signature#1{%
  \@ifundefined{@signatureA}{\gdef\@signatureA{#1}}{%
  \@ifundefined{@signatureB}{\gdef\@signatureB{#1}}{%
  \@ifundefined{@signatureC}{\gdef\@signatureC{#1}}{%
  \@ifundefined{@signatureD}{\gdef\@signatureD{#1}}{%
    \gdef\@signatureE{#1}%
  }}}}%
}

\def\deansignature#1{\gdef\@deansignatureName{#1}}

% \newchapter{file} — include a thesis chapter
\def\newchapter#1{%
  \ifbool{@gotfirstchapter}{}{%
    \booltrue{@gotfirstchapter}%
    \initialstuff%
  }%
  \include{#1}%
}

% \newappendix{file} — include an appendix
\def\newappendix#1{%
  \ifbool{@gotfirstappendix}{%
    \immediate\write\@mainaux{\string\gdef\string\@multappendix{Y}}%
  }{%
    \booltrue{@gotfirstappendix}%
    \boolfalse{@sequential}% appendix figures/tables must not be sequential
    \startappendix%
    \immediate\write\@auxout{%
      \string\@writefile{toc}{{\vskip 1.0ex plus\p@
        {\string\bfseries \noindent APPENDIX \hfill}}}}%
    \immediate\write\@auxout{\string\@writefile{toc}{ }}%
  }%
  \include{#1}%
}

%----------------------------------------------------------------------
% Page dimensions
% Left margin: 1.6in; other margins: 1.1in; page numbers placed correctly.
%----------------------------------------------------------------------

\newlength{\@realheadsep}
\newlength{\@realtextheight}

\setlength{\oddsidemargin}{.6in}
\setlength{\textwidth}{5.8in}
\setlength{\marginparsep}{.2in}
\setlength{\marginparwidth}{1in}

\setlength{\topmargin}{-0.5in}
\setlength{\headheight}{0.25in}
\setlength{\@realheadsep}{0.35in}
\setlength{\@realtextheight}{8.8in}
\setlength{\footskip}{.5in}

\setlength{\paperheight}{11.0in}
\setlength{\paperwidth}{8.5in}

\setlength{\headsep}{\@realheadsep}
\setlength{\textheight}{\@realtextheight}

% Paragraph indentation
\parindent 2em

% Extra lengths used by capheadings (list-of-figures/tables pages)
\newlength{\@headerextra}
\setlength{\@headerextra}{0.35in}

\newlength{\@altheadsep}
\setlength{\@altheadsep}{\@realheadsep}
\addtolength{\@altheadsep}{\@headerextra}

\newlength{\@alttextheight}
\setlength{\@alttextheight}{\@realtextheight}
\addtolength{\@alttextheight}{-\@headerextra}

\newlength{\@fullheadheight}
\setlength{\@fullheadheight}{\headheight}
\addtolength{\@fullheadheight}{\@realheadsep}

\newlength{\@headtofootheight}
\setlength{\@headtofootheight}{\@alttextheight}
\addtolength{\@headtofootheight}{\@realheadsep}
\addtolength{\@headtofootheight}{\@headerextra}

%----------------------------------------------------------------------
% Spacing commands
%----------------------------------------------------------------------

% Double-spacing tuned for each supported font size
\def\doublespace{%
  \renewcommand{\baselinestretch}{1.66}%
  \renewcommand{\arraystretch}{0.602}%
  \normalsize%
}

\def\@tmppt{11pt}
\ifx\@optptsize\@tmppt
  \def\doublespace{%
    \renewcommand{\baselinestretch}{1.62}%
    \renewcommand{\arraystretch}{0.617}%
    \normalsize%
  }
\fi

\def\@tmppt{10pt}
\ifx\@optptsize\@tmppt
  \def\doublespace{%
    \renewcommand{\baselinestretch}{1.67}%
    \renewcommand{\arraystretch}{0.599}%
    \normalsize%
  }
\fi

\def\singlespace{%
  \renewcommand{\baselinestretch}{1.0}%
  \renewcommand{\arraystretch}{1.0}%
  \normalsize%
}

% Default to double-spacing
\doublespace

% Suppress spurious hyperref warning about missing TOC level
\providecommand*{\toclevel@chapterx}{0}

%----------------------------------------------------------------------
% Basic definitions
%----------------------------------------------------------------------

\def\@worktype{%
  \ifbool{@masters}{Thesis}{Dissertation}%
}

% Defaults
\def\@title{}
\def\@author{}
\def\@dept{ELECTRICAL ENGINEERING}
\def\@copyrightyear{\number\the\year}
\def\@reffile{references}
\def\@titledisclaimer{}

% Bibliography aux file (written alongside the main .aux)
\def\@bibliofileext{bib}
\def\@bibliofile{\jobname\@bibliofileext}

% Chapter/section heading names
\renewcommand\contentsname{TABLE OF CONTENTS}
\renewcommand\listtablename{LIST OF TABLES}
\renewcommand\listfigurename{LIST OF FIGURES}
\ifbool{@wantchapterref}{%
  \newcommand\listrefname{List of References}%
}{%
  \newcommand\listrefname{LIST OF REFERENCES}%
}
\newcommand\biblioname{BIBLIOGRAPHY}
\ifbool{@wantmanuscript}{%
  \renewcommand\chaptername{MANUSCRIPT}%
}{%
  \renewcommand\chaptername{CHAPTER}%
}

% State flags
\newbool{@gotfirstchapter}   \boolfalse{@gotfirstchapter}
\newbool{@gotfirstappendix}  \boolfalse{@gotfirstappendix}

% Count citations per chapter (for deciding whether to emit per-chapter refs)
\newcounter{chaptercitecount}

% Called from the main .aux to request list-of-figures / list-of-tables pages
\def\myusefigurespage{\gdef\@myusefigurespage{true}}
\def\myusetablespage{\gdef\@myusetablespage{true}}

% Running totals used to decide whether those pages are needed
\newcounter{totaltablecount}
\newcounter{totalfigurecount}

\newbool{@usefigurespage}  \boolfalse{@usefigurespage}
\newbool{@usetablespage}   \boolfalse{@usetablespage}

% Hook expanded into each .bbl file to add the TOC entry at the right page
\def\addcustomcontentsline{}

%----------------------------------------------------------------------
% BibTeX file-list accumulator
% Collects names of .aux files that need bibtex run, prints them at end.
%----------------------------------------------------------------------
\def\add@biblist#1{%
  \@ifundefined{@biblist}{%
    \edef\@biblist{ bibtex #1}%
  }{%
    \edef\@tmpbl{\@biblist^^J bibtex #1}%
    \let\@biblist=\@tmpbl%
  }%
}

% \@hashchar holds a literal # with catcode 12 (other).
% Inside \AtEndDocument{...} the argument is stored in a token list, so a
% raw # would be treated as a macro-parameter marker and doubled when
% written.  Using \@hashchar avoids that and lets us write a valid shebang.
{%
  \catcode`\#=12\relax
  \gdef\@hashchar{#}%
}

%----------------------------------------------------------------------
% Per-chapter reference machinery (chapterref mode)
%
% This reimplements the core of chapterbib.sty directly so that we can
% inject the .bbl file at exactly the right point (before \clearpage)
% and count citations per chapter to suppress empty reference sections.
% We keep this self-contained rather than depending on chapterbib.sty
% to avoid version-skew issues with that external package.
%----------------------------------------------------------------------

\ifbool{@wantchapterref}{

  % ---------- Helpers adapted from chapterbib.sty ----------

  \def\@CB@writeContext{%
    \if@filesw
      \begingroup
        \edef\@tempa{%
          \string\gdef\string\@extra@binfo{\@extra@b@citeb}}%
        \immediate\write\@auxout{\@tempa\@CB@wtoc{toc}\@CB@wtoc{lof}\@CB@wtoc{lot}}%
      \endgroup
    \fi
  }

  \def\@CB@wtoc#1{%
    \string\@writefile{#1}{%
      \gdef\string\the@ipfilectr{\@extra@b@citeb}}}

  % ---------- \@include override ----------
  % Extends the standard \@include to:
  %   (a) tag each chapter's citations with a unique counter suffix
  %   (b) write bibstyle/bibdata directives to the chapter .aux
  %   (c) inject the chapter .bbl if any citations were found
  %   (d) fire all LaTeX 2020+ include hooks so hyperref and other
  %       packages continue to work correctly
  %
  % Changes vs. original:
  %   - \ifx\@nodocument\relax guard (matches modern latex.ltx)
  %   - \@filehook@set@CurrentFile call (notifies packages of the
  %     current file; needed by hyperref for anchor scoping)
  %   - \UseHook / \UseOneTimeHook calls for include/before,
  %     include/end, and include/after (LaTeX 2020+ include hooks)
  %   - Quoted filename in \openout for path-safe file handling
  %   - Second \clearpage before \@writeckpt (matches modern latex.ltx)

  \def\@include#1 {%
    \ifx\@nodocument\relax
    \clearpage
    % Advance chapter counter and set the citation-tagging suffix
    \global\advance\c@inputfile\@ne
    \xdef\the@ipfilectr{@-\the\c@inputfile}%
    \@CB@writeContext
    \xdef\@currentipfile{#1}%
    \if@filesw
      \immediate\write\@mainaux{\string\@input{#1.aux}}%
    \fi
    \@tempswatrue
    \if@partsw
      \@tempswafalse
      \edef\reserved@b{#1}%
      \@for\reserved@a:=\@partlist\do{%
        \ifx\reserved@a\reserved@b\@tempswatrue\fi}%
    \fi
    \if@tempswa
      \let\@auxout\@partaux
      \if@filesw
        \immediate\openout\@partaux "#1.aux"% quoted for path safety
        \immediate\write\@partaux{\relax}%
      \fi
      % Notify packages (especially hyperref) of the current include file
      \@ifundefined{@filehook@set@CurrentFile}{}{\@filehook@set@CurrentFile}%
      \UseHook{include/before}%
      \UseOneTimeHook{include/#1/before}%
      \@input@{#1.tex}%
      \UseOneTimeHook{include/#1/end}%
      \UseHook{include/end}%
      % Write bib directives to the chapter .aux, then inject .bbl if needed
      \if@filesw
        \immediate\write\@auxout{\string\bibstyle{\@refbstfile}}%
        \immediate\write\@auxout{\string\bibdata{\@reffile}}%
      \fi
      \ifnum\value{chaptercitecount}>0
        \ifbool{@nobib}{}{%
          \def\addcustomcontentsline{%
            \addcontentsline{toc}{section}{\listrefname}}%
          \@input{\@currentipfile.bbl}%
          \add@biblist{\@currentipfile}%
        }%
      \fi
      \clearpage
      \UseOneTimeHook{include/#1/after}%
      \UseHook{include/after}%
      \clearpage
      \@writeckpt{#1}%
      \if@filesw\immediate\closeout\@partaux\fi
    \else
      \deadcycles\z@
      \@nameuse{cp@#1}%
    \fi
    \let\@auxout\@mainaux
    % Restore chapterbib-style context
    \global\let\@currentipfile\@savedjobname
    \gdef\the@ipfilectr{}%
    \@CB@writeContext
    \fi% closes \ifx\@nodocument\relax
  }

  % ---------- Citation disambiguation (from chapterbib.sty) ----------

  % Each \bibcite entry is scoped to its chapter via \@extra@binfo
  \@ifundefined{@extra@binfo}{%
    \def\bibcite#1#2{%
      \global\@namedef{b@#1\@extra@binfo}{#2}}%
  }{}

  % \@citex extended to tag citations, count them, and write to two aux streams
  \@ifundefined{@extra@b@citeb}{%
    \def\@citex[#1]#2{%
      \let\@citea\@empty
      \@cite{%
        \@for\@citeb:=#2\do{%
          \@citea\let\@citea\citepunct
          \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
          \stepcounter{chaptercitecount}%
          \if@filesw
            \immediate\write\@auxout{\string\citation{\@citeb}}%
            \ifbool{@wantbiblio}{\immediate\write12{\string\citation{\@citeb}}}{}%
          \fi
          \@ifundefined{b@\@citeb\@extra@b@citeb}{%
            \mbox{\reset@font\bfseries ?}%
            \@warning{%
              Citation `\@citeb' in file `\@currentipfile'
              on page \thepage\space undefined}%
            \G@refundefinedtrue
          }{%
            \hbox{\citeform{\csname b@\@citeb\@extra@b@citeb\endcsname}}%
          }%
        }%
      }{#1}%
    }
    \@ifundefined{citeform}{\let\citeform\@empty}{}
    \@ifundefined{citepunct}{\def\citepunct{,\penalty\@m\ }}{}
  }{}

  % Initialise chapterbib counters/macros
  \xdef\@savedjobname{\jobname}
  \let\@currentipfile\@savedjobname
  \gdef\the@ipfilectr{}
  \def\@extra@b@citeb{\the@ipfilectr}
  \newcount\c@inputfile \global\c@inputfile=\z@
  \gdef\@extra@binfo{}% clear stale value from old runs

}{%\ifbool{@wantchapterref} — else branch (oneref / simpleref)

  % Single-list \@citex: writes to both aux streams, no chapter scoping
  \def\@citex[#1]#2{%
    \let\@citea\@empty
    \@cite{%
      \@for\@citeb:=#2\do{%
        \ifbool{@wantapalike}{%
          \@citea\def\@citea{; }%
        }{%
          \@citea\def\@citea{,\penalty\@m\ }%
        }%
        \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
        \if@filesw
          \immediate\write\@auxout{\string\citation{\@citeb}}%
          \ifbool{@wantbiblio}{\immediate\write12{\string\citation{\@citeb}}}{}%
        \fi
        \@ifundefined{b@\@citeb}{%
          \mbox{\reset@font\bfseries ?}%
          \G@refundefinedtrue
          \@latex@warning{%
            Citation `\@citeb' on page \thepage\space undefined}%
        }{%
          \hbox{\csname b@\@citeb\endcsname}%
        }%
      }%
    }{#1}%
  }

}% end \ifbool{@wantchapterref}

%----------------------------------------------------------------------
% AtBeginDocument hooks
%----------------------------------------------------------------------

\AtBeginDocument{%
  % \nocite writes to the bibliography aux stream (stream 12) so that works
  % consulted but not cited can appear in the BIBLIOGRAPHY section.
  % Stream 12 is only open when the [bibliography] class option is active.
  \def\nocite#1{%
    \@bsphack
    \@for\@citeb:=#1\do{%
      \edef\@citeb{\expandafter\@firstofone\@citeb}%
      \ifbool{@wantbiblio}{%
        \if@filesw\immediate\write12{\string\citation{\@citeb}}\fi
      }{}%
    }%
    \@esphack
  }%

  % Neutralise \bibliography and \bibliographystyle — the class handles these.
  \def\bibliography#1{}%
  \def\bibliographystyle#1{}%

  % Patch cite.sty's \@nocite if it is loaded, to also count chapter refs
  % and write to the bibliography aux stream.
  \@ifundefined{@extra@b@citeb}{}{%
    \def\@nocite#1{%
      \begingroup
        \let\protect\string
        \xdef\@no@sparg{\expandafter\@ignsp#1 \: }%
      \endgroup
      \if@filesw\immediate\write\@auxout{\string\citation{\@no@sparg}}\fi
      \stepcounter{chaptercitecount}%
      \ifbool{@wantbiblio}{%
        \if@filesw\immediate\write12{\string\citation{\@no@sparg}}\fi
      }{}%
    }%
  }%
}

% Backward-compatibility alias
\def\bibliocite#1{\nocite{#1}}

%----------------------------------------------------------------------
% Reference list environment (per-chapter or one-ref)
%----------------------------------------------------------------------

\renewenvironment{thebibliography}[1]{%
  \ifbool{@wantchapterref}{%
    \section*{\listrefname}%
  }{%
    \chapter*{\listrefname}%
  }%
  \singlespace\vspace{2ex}%
  \list{\@biblabel{\@arabic\c@enumiv}}{%
    \settowidth\labelwidth{\@biblabel{#1}}%
    \leftmargin\labelwidth
    \ifbool{@wantapalike}{%
      \setlength{\leftmargin}{2.0em}%
      \addtolength{\leftmargin}{-\labelsep}%
      \setlength{\itemindent}{-2.0em}%
    }{}%
    \advance\leftmargin\labelsep
    \@openbib@code
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \renewcommand\theenumiv{\@arabic\c@enumiv}%
  }%
  \sloppy
  \clubpenalty4000
  \@clubpenalty\clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m
}{%
  \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

%----------------------------------------------------------------------
% Bibliography environment (separate from references, sorted alphabetically)
%----------------------------------------------------------------------

\newenvironment{thesisbib}[1]{%
  \chapter*{\biblioname}%
  \singlespace\vspace{2ex}%
  \list{\@biblabel{\@arabic\c@enumiv}}{%
    \setlength{\leftmargin}{2.0em}%
    \addtolength{\leftmargin}{-\labelsep}%
    \setlength{\itemindent}{-2.0em}%
    \advance\leftmargin\labelsep
    \@openbib@code
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \renewcommand\theenumiv{\@arabic\c@enumiv}%
  }%
  \sloppy
  \clubpenalty4000
  \@clubpenalty\clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m
}{%
  \def\@noitemerr{\@latex@warning{Empty `thesisbib' environment}}%
  \endlist
}

%----------------------------------------------------------------------
% Page styles
%----------------------------------------------------------------------

% Used instead of ps@plain when page numbers are on the top (topnum option)
\def\ps@plaintop{%
  \let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
  \let\@evenhead\@empty
  \def\@oddhead{\reset@font\hfil\thepage}%
}

% Page style for list-of-figures and list-of-tables pages.
% The header draws both the column heading and the page number, because
% \textheight may be wrong on the last page of a single-entry list.
\def\ps@capheadings{%
  \let\@mkboth\@gobbletwo
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
  \let\@evenhead\@empty
  \def\@oddhead{%
    \settoheight{\@tmpheighta}{\rightmark}%
    \settoheight{\@tmpheightb}{\thepage}%
    \shortstack{%
      \rule{0in}{\@fullheadheight}\rule{\textwidth}{0in}\\%
      \rightmark\\%
      \rule{0in}{\@headtofootheight}%
        \vspace{-\@tmpheighta}\vspace{-\@tmpheightb}\\%
      \thepage%
    }%
  }%
}

%----------------------------------------------------------------------
% Chapter/section heading formatting
%----------------------------------------------------------------------

\def\@makechapterhead#1{{%
  \renewcommand{\baselinestretch}{1.0}\bfseries
  \begin{center}
    \rule{0in}{0.5in}%
    \MakeUppercase{\@chapapp}%
    \@ifundefined{@usesingappend}{\space\thechapter}{}%
    \vspace{2.0ex}\\%
    #1
    \vskip 2.0ex
  \end{center}
}}

% TOC entry for numbered chapter headings
\renewcommand*\l@chapter[2]{%
  \vskip 1.0ex \@plus\p@
  {\@dottedtocline{0}{1.5em}{1.5em}{\bfseries\noindent#1}{#2}}%
}

% TOC entry for unnumbered chapter headings (abstract, TOC itself, etc.)
\newcommand*\l@chapterx[2]{%
  \vskip 1.0ex \@plus\p@
  {\@dottedtocline{0}{0em}{1.5em}{\bfseries\noindent#1}{#2}}%
}

% Indentation of TOC section entries
\renewcommand*\l@section{\@dottedtocline{1}{3.0em}{4.0em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{5.3em}{4.9em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{8.5em}{5.6em}}

% Remove 1.7em indentation on the first line of numbered TOC entries.
% (Runover lines in multi-line captions still get the indent via l@figure.)
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
    \begingroup
      #6{\@hangfrom{\hskip #3\relax\@svsec}%
        \interlinepenalty\@M #8\@@par}%
    \endgroup
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth\else
        \protect\numberline{\csname the#1\endcsname}\hspace{-1.7em}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax\@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth\else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}%
    }%
  \fi
  \@xsect{#5}%
}

% List-of-figures/tables entries: extra 1.7em indent to allow runover alignment
\renewcommand*\l@figure{\@dottedtocline{1}{1.5em}{4.0em}}
\let\l@table\l@figure

% Caption formatting: -1.7em on first line so runover lines align
\long\def\@caption#1[#2]#3{%
  \par
  \ifbool{@gotfirstappendix}{}{%
    % Appendix figures/tables are intentionally excluded from the lists
    \addcontentsline{\csname ext@#1\endcsname}{#1}{%
      \protect\numberline{\csname the#1\endcsname}{\hspace{-1.7em}%
        \ignorespaces #2}}%
  }%
  \begingroup
    \@parboxrestore
    \if@minipage\@setminipage\fi
    \normalsize
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup
}

% Heading for unnumbered chapters (abstract, bibliography, etc.)
\def\@schapteroffset{0.0in}
\def\@makeschapterhead#1{{%
  \renewcommand{\baselinestretch}{1.0}\bfseries
  \begin{center}
    \rule{0in}{\@schapteroffset}%
    #1
    \vskip 2.0ex
  \end{center}
}}

% Reset per-chapter counters appropriately
\def\cl@chapter{%
  \setcounter{chaptercitecount}{0}%
  \ifbool{@sequential}{%
    \@elt{section}\@elt{footnote}%
  }{%
    \@elt{equation}\@elt{figure}\@elt{footnote}\@elt{section}\@elt{table}%
  }%
}

% Section-level heading formats
\renewcommand\section{%
  \@startsection{section}{1}{\z@}{4.0ex}{0.01ex}%
    {\renewcommand{\baselinestretch}{1.0}\normalfont\normalsize\bfseries}}
\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}{4.0ex}{0.01ex}%
    {\renewcommand{\baselinestretch}{1.0}\normalfont\normalsize\bfseries}}
\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}{4.0ex}{0.01ex}%
    {\renewcommand{\baselinestretch}{1.0}\normalfont\normalsize\bfseries}}

% Figure/table/equation numbering (sequential or chapter-prefixed)
\renewcommand\thefigure{%
  \addtocounter{totalfigurecount}{1}%
  \ifbool{@sequential}{}{\thechapter.}\@arabic\c@figure}
\renewcommand\thetable{%
  \addtocounter{totaltablecount}{1}%
  \ifbool{@sequential}{}{\thechapter.}\@arabic\c@table}
\renewcommand\theequation{%
  \ifbool{@sequential}{}{\thechapter.}\@arabic\c@equation}

% Single-spacing in floats, footnotes, and special environments
\def\@floatboxreset{%
  \singlespace\reset@font\normalsize\@setminipage}

\let\uri@footnotetext\@footnotetext
\def\@footnotetext#1{{\singlespace\uri@footnotetext{#1}}}

\renewenvironment{quotation}{%
  \list{}{\singlespace\listparindent 1.5em\itemindent\listparindent
    \rightmargin\leftmargin\parsep\z@\@plus\p@}\item\relax%
}{\endlist}

\renewenvironment{quote}{%
  \list{}{\singlespace\rightmargin\leftmargin}\item\relax%
}{\endlist}

\def\verbatim{\singlespace\@verbatim\frenchspacing\@vobeyspaces\@xverbatim}

% Captions use a period separator instead of a colon
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1. #2}%
  \ifdim\wd\@tempboxa>\hsize
    #1. #2\par
  \else
    \global\@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

% Make the first paragraph of each chapter indented
\renewcommand\chapter{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{plain}%
  \global\@topnum\z@
  \@afterindenttrue
  \secdef\@chapter\@schapter}

% Chapter TOC entry: suppress chapter number if using single appendix
\def\@chapter[#1]#2{%
  \ifnum\c@secnumdepth>\m@ne
    \refstepcounter{chapter}%
    \typeout{\@chapapp\space\thechapter.}%
    \ifbool{@gotfirstappendix}{%
      \@ifundefined{@usesingappend}{%
        \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
      }{%
        \addcontentsline{toc}{chapter}{#1}%
      }%
    }{%
      \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
    }%
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi
}

%----------------------------------------------------------------------
% Preliminary pages
%----------------------------------------------------------------------

\def\titlepage{%
  \thispagestyle{empty}%
  \begin{center}
    {\MakeUppercase{\@title} \\
     BY \\
     \MakeUppercase{\@author}}
  \end{center}
  \vfill
  \begin{center}\@titledisclaimer\end{center}
  \vfill
  \begin{center}
    A \MakeUppercase{\@worktype}
    SUBMITTED IN PARTIAL FULFILLMENT OF THE\\
    REQUIREMENTS FOR THE DEGREE OF\\
    \ifbool{@masters}{MASTER OF SCIENCE\\}{DOCTOR OF PHILOSOPHY\\}%
    IN\\
    \MakeUppercase{\@dept}
  \end{center}
  \vfill
  \begin{center}\@titledisclaimer\end{center}
  \vfill
  \begin{center}
    UNIVERSITY OF RHODE ISLAND\\
    {\@copyrightyear}
  \end{center}
  \newpage
}

\def\signaturepage{%
  % Ensure undefined signatures default to empty
  \@ifundefined{@signatureA}{\gdef\@signatureA{}}{}%
  \@ifundefined{@signatureB}{\gdef\@signatureB{}}{}%
  \@ifundefined{@signatureC}{\gdef\@signatureC{}}{}%
  \@ifundefined{@signatureD}{\gdef\@signatureD{}}{}%
  \@ifundefined{@signatureE}{\gdef\@signatureE{}}{}%
  \@ifundefined{@deansignatureName}{\gdef\@deansignatureName{}}{}%
  \ifbool{@electronic}{%
    \def\siglinewidth{0pt}%
    \def\siglineheight{0.2in}%
  }{%
    \def\siglinewidth{0.4pt}%
    \def\siglineheight{0.4in}%
  }%
  \thispagestyle{empty}%
  \begin{center}
    \ifbool{@masters}{MASTER OF SCIENCE THESIS\\}{DOCTOR OF PHILOSOPHY DISSERTATION\\}%
    OF\\
    \MakeUppercase{\@author}
  \end{center}
  \vfill
  APPROVED:\\\vspace{-1.0em}\\
  \ifbool{@electronic}{%
    \null\hfill\begin{tabular}{rl}
      {\@worktype} Committee:\hspace{0.5in}\mbox{}\\\\
      Major Professor & \rule[-0.1in]{3in}{\siglinewidth}\hspace{-3in}\@signatureA\\
      & \shortstack[l]{\rule{0in}{\siglineheight}\@signatureB\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      & \shortstack[l]{\rule{0in}{\siglineheight}\@signatureC\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      \ifbool{@fourcommittee}{%
        & \shortstack[l]{\rule{0in}{\siglineheight}\@signatureD\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      }{}%
      \ifbool{@fivecommittee}{%
        & \shortstack[l]{\rule{0in}{\siglineheight}\@signatureE\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      }{}%
      & \shortstack[l]{\rule{0in}{\siglineheight}\@deansignatureName\\\rule[-0.1in]{3in}{\siglinewidth}\\
                       DEAN OF THE GRADUATE SCHOOL}\\
    \end{tabular}
  }{%
    \null\hfill\begin{tabular}{rl}
      {\@worktype} Committee:\hspace{0.5in}\mbox{}\\\\
      Major Professor & \rule[-0.1in]{3in}{\siglinewidth}\hspace{-3in}\\
      & \@signatureA\\
      & \shortstack[l]{\rule{0in}{\siglineheight}\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      & \@signatureB\\
      & \shortstack[l]{\rule{0in}{\siglineheight}\\\rule[-0.1in]{3in}{\siglinewidth}}\\
      & \@signatureC\\
      \ifbool{@fourcommittee}{%
        & \shortstack[l]{\rule{0in}{\siglineheight}\\\rule[-0.1in]{3in}{\siglinewidth}}\\
        & \@signatureD\\
      }{}%
      \ifbool{@fivecommittee}{%
        & \shortstack[l]{\rule{0in}{\siglineheight}\\\rule[-0.1in]{3in}{\siglinewidth}}\\
        & \@signatureE\\
      }{}%
      & \shortstack[l]{\rule{0in}{\siglineheight}\rule[-0.1in]{3in}{\siglinewidth}\\
                       \@deansignatureName\\
                       DEAN OF THE GRADUATE SCHOOL}\\
    \end{tabular}
  }%
  \vfill
  \begin{center}
    UNIVERSITY OF RHODE ISLAND\\
    {\@copyrightyear}
  \end{center}
}

\def\abstractpages{%
  \@ifundefined{@abstract}{}{%
    \newpage
    \sloppy
    \chapter*{ABSTRACT}
    \addcontentsline{toc}{chapterx}{ABSTRACT}
    \thispagestyle{empty}%
    \pagestyle{empty}%
    \input{\@abstract}%
  }%
}

\def\acknowledgementpage{%
  \@ifundefined{@acknowledgements}{}{%
    \newpage
    \pagestyle{plain}%
    \chapter*{ACKNOWLEDGMENTS}
    \addcontentsline{toc}{chapterx}{ACKNOWLEDGMENTS}
    \input{\@acknowledgements}%
  }%
}

\def\dedicationpage{%
  \@ifundefined{@dedication}{}{%
    \newpage
    \pagestyle{plain}%
    \chapter*{DEDICATION}
    \addcontentsline{toc}{chapterx}{DEDICATION}
    \mbox{}\vfill
    \input{\@dedication}%
    \vfill
  }%
}

\def\prefacepages{%
  \@ifundefined{@preface}{}{%
    \newpage
    \pagestyle{plain}%
    \chapter*{PREFACE}
    \addcontentsline{toc}{chapterx}{PREFACE}
    \input{\@preface}%
  }%
}

% Table of contents
\def\contentspages{%
  \setcounter{@tmppage}{\value{page}}%
  {%
    \addvspace{10pt}%
    \let\saveaddvspace\addvspace
    \def\addvspace##1{}%
    \singlespace
    \setlength{\parskip}{1em}%
    \chapter*{\contentsname}%
    \addcontentsline{toc}{chapterx}{\contentsname}%
    \pagestyle{capheadings}%
    \markboth{}{{\bfseries\hfill Page}}%
    \@starttoc{toc}%
    \let\addvspace\saveaddvspace
  }%
  \ifnum\value{@tmppage}<\value{page}%
    \thispagestyle{capheadings}%
  \fi
}

% List of tables
\def\tablespage{%
  \setcounter{@tmppage}{\value{page}}%
  {%
    \addvspace{10pt}%
    \let\saveaddvspace\addvspace
    \def\addvspace##1{}%
    \singlespace
    \setlength{\parskip}{1em}%
    \chapter*{\listtablename}%
    \addcontentsline{toc}{chapterx}{\listtablename}%
    \pagestyle{capheadings}%
    \markboth{}{{\bfseries Table \hfill Page}}%
    {\bfseries\noindent Table \hfill Page}\\\vspace{-1em}%
    \@starttoc{lot}%
    \let\addvspace\saveaddvspace
  }%
  \ifnum\value{@tmppage}<\value{page}%
    \thispagestyle{capheadings}%
  \fi
}

% List of figures
\def\figurespage{%
  \setcounter{@tmppage}{\value{page}}%
  {%
    \addvspace{10pt}%
    \let\saveaddvspace\addvspace
    \def\addvspace##1{}%
    \singlespace
    \setlength{\parskip}{1em}%
    \chapter*{\listfigurename}%
    \addcontentsline{toc}{chapterx}{\listfigurename}%
    \pagestyle{capheadings}%
    \markboth{}{{\bfseries Figure \hfill Page}}%
    {\bfseries\noindent Figure \hfill Page}\\\vspace{-1em}%
    \@starttoc{lof}%
    \let\addvspace\saveaddvspace
  }%
  \ifnum\value{@tmppage}<\value{page}%
    \thispagestyle{capheadings}%
  \fi
}

% All preliminary pages up to chapter 1
\def\startingpages{%
  \pagenumbering{arabic}%
  \setcounter{page}{0}%
  \titlepage
  \pagenumbering{roman}%
  \pagestyle{plain}%
  \signaturepage
  \abstractpages
  \acknowledgementpage
  \dedicationpage
  \prefacepages
  %
  \setlength{\textheight}{\@alttextheight}%
  \newpage
  \pagestyle{plain}%
  \setlength{\headsep}{\@altheadsep}%
  \contentspages
  \setlength{\textheight}{\@realtextheight}%
  \ifbool{@usefigurespage}{%
    \setlength{\textheight}{\@alttextheight}%
    \newpage
    \setlength{\headsep}{\@altheadsep}%
    \figurespage
    \setlength{\textheight}{\@realtextheight}%
  }{}%
  \ifbool{@usetablespage}{%
    \setlength{\textheight}{\@alttextheight}%
    \newpage
    \setlength{\headsep}{\@altheadsep}%
    \tablespage
    \setlength{\textheight}{\@realtextheight}%
    \pagestyle{capheadings}%
  }{}%
  \addtocontents{toc}{{\vskip 1.0ex \@plus\p@
    {\bfseries\noindent\chaptername\hfill}}}%
  \addtocontents{toc}{ }%
  \newpage
  \setlength{\headsep}{\@realheadsep}%
}

%----------------------------------------------------------------------
% Startup — called by \newchapter before the first chapter is included
%----------------------------------------------------------------------

\def\initialstuff{%
  % Open the combined bibliography aux file (stream 12) only when the
  % [bibliography] option is active.  Without it the thesisbib section
  % is suppressed entirely and bibtex thesisbib is never needed.
  \ifbool{@wantbiblio}{%
    \immediate\openout12=\@bibliofile.aux
    \immediate\write12{\string\bibstyle{uribib}}%
    \immediate\write12{\string\bibdata{\@reffile}}%
  }{}
  %
  \@ifundefined{@myusefigurespage}{}{\booltrue{@usefigurespage}}%
  \@ifundefined{@myusetablespage}{}{\booltrue{@usetablespage}}%
  %
  \newcounter{@tmppage}%
  \newlength{\@tmpheighta}%
  \newlength{\@tmpheightb}%
  \ifbool{@noprelim}{}{\startingpages}%
  \pagenumbering{arabic}%
  \ifbool{@topnumbers}{\def\ps@plain{\ps@plaintop}}{}%
  \pagestyle{plain}%
  \def\@schapteroffset{0.5in}%
}

%----------------------------------------------------------------------
% Appendix transition
%----------------------------------------------------------------------

\def\startappendix{%
  \@ifundefined{@multappendix}{\def\@usesingappend{Y}}{}%
  \ifbool{@wantchapterref}{}{%
    \def\addcustomcontentsline{%
      \addcontentsline{toc}{chapterx}{\listrefname}}%
    \if@filesw\immediate\write\@auxout{\string\bibstyle{\@refbstfile}}\fi
    \ifbool{@simpleref}{}{%
      \if@filesw\immediate\write\@auxout{\string\bibdata{\@reffile}}\fi
      \@input{\jobname.bbl}%
      \add@biblist{\jobname}%
    }%
    \newpage
  }%
  \appendix
}

%----------------------------------------------------------------------
% Decide whether list-of-figures/tables pages are needed
%----------------------------------------------------------------------

\def\@addfigtbl{%
  \ifnum\value{totalfigurecount}>0
    \if@filesw\immediate\write\@auxout{\string\myusefigurespage}\fi
  \fi
  \ifnum\value{totaltablecount}>0
    \if@filesw\immediate\write\@auxout{\string\myusetablespage}\fi
  \fi
}

%----------------------------------------------------------------------
% Bibliography emission — called at \end{document}
%----------------------------------------------------------------------

\def\biblio{%
  \ifbool{@nobib}{}{%
    \ifbool{@simpleref}{%
      \if@filesw\immediate\write\@auxout{\string\bibdata{\@reffile}}\fi
      \ifbool{@noprelim}{%
        \if@filesw\immediate\write\@auxout{\string\bibstyle{\@refbstfile}}\fi
      }{%
        \@addfigtbl
      }%
      \@input{\jobname.bbl}%
      \add@biblist{\jobname}%
    }{%
      \ifbool{@gotfirstappendix}{}{\startappendix}%
      \@addfigtbl
      % The combined alphabetical BIBLIOGRAPHY section (thesisbib.bbl) is only
      % emitted when the [bibliography] class option is given.  Without it, the
      % per-chapter or single reference list is the only bibliography section.
      \ifbool{@wantbiblio}{%
        \@input{\@bibliofile.bbl}%
        \add@biblist{\@bibliofile}%
      }{}%
    }%
  }%
}

%----------------------------------------------------------------------
% End-of-document hook
%
% Using \AtEndDocument is the modern, correct approach. It participates
% properly in the hook system introduced in LaTeX 2020 and does not
% require overriding \enddocument. The BibTeX reminder message is
% written after the final \clearpage so it is not buried in other output.
%
% We write two output files:
%   genbib.sh  — a complete, executable shell script that runs the full
%                compile sequence: pdflatex, bibtex (once per chapter/bib
%                aux), then two final pdflatex passes.  This is the only
%                file users need to worry about.
%   genbib.txt — the plain-text list of bibtex commands kept for backward
%                compatibility (older documentation references it).
%----------------------------------------------------------------------

\AtEndDocument{%
  \biblio
  \@ifundefined{@biblist}{}{%
    \clearpage
    %
    % ----- Console reminder -----
    \immediate\write16{}%
    \immediate\write16{** Bibliography info: run genbib.sh (or follow the}%
    \immediate\write16{** steps in genbib.txt) to complete the compile. **}%
    \immediate\write16{}%
    %
    % ----- genbib.txt (backward-compat plain list) -----
    \immediate\openout13=genbib.txt
    \immediate\write13{\@biblist}%
    \immediate\closeout13
    %
    % ----- genbib.sh (complete, ready-to-run shell script) -----
    \immediate\openout14=genbib.sh
    \immediate\write14{\@hashchar!/bin/sh}%
    \immediate\write14{\@hashchar\space genbib.sh --- auto-generated by urithesis.cls}%
    \immediate\write14{\@hashchar\space Run this script from the directory containing your .tex files}%
    \immediate\write14{\@hashchar\space to produce a fully resolved PDF.}%
    \immediate\write14{}%
    \immediate\write14{set -e}%
    \immediate\write14{}%
    \immediate\write14{echo "==> Pass 1: pdflatex (collecting citations)..."}%
    \immediate\write14{pdflatex \jobname}%
    \immediate\write14{}%
    \immediate\write14{echo "==> Running BibTeX on each aux file..."}%
    \immediate\write14{\@biblist}%
    \immediate\write14{}%
    \immediate\write14{echo "==> Pass 2: pdflatex (reading .bbl files)..."}%
    \immediate\write14{pdflatex \jobname}%
    \immediate\write14{}%
    \immediate\write14{echo "==> Pass 3: pdflatex (resolving cross-references)..."}%
    \immediate\write14{pdflatex \jobname}%
    \immediate\write14{}%
    \immediate\write14{echo "==> Done. Output: \jobname.pdf"}%
    \immediate\closeout14
  }%
}

%% End of urithesis.cls