% Document class for class notes, includes a nice style and
% several useful packages.
%
% Guillermo Julián, EPFL
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nicenotes}[2016/09/19 Note taking class]

\def\titlepagebuilddate{\tiny Last update: \today\, \currenttime}

\newif\if@shortheader
\@shortheaderfalse
\newcommand{\organization}{EPFL}

%%%% Font selection
\renewcommand{\rmdefault}{ppl}
\renewcommand{\sfdefault}{fla}
\renewcommand{\ttdefault}{lmtt}
\renewcommand*{\familydefault}{\rmdefault}
\message{Loading Palatino fonts}

%%%% Class options
\DeclareOption{nobuilddate}{%
	\def\titlepagebuilddate{}%
}

\DeclareOption{shortheader}{
	\@shortheadertrue
}

\DeclareOption{bibnumbers}{
	\PassOptionsToPackage{numbers}{natbib}
}

\newif\if@twoside
\DeclareOption{oneside}{
	\PassOptionsToClass{oneside}{memoir}
	\@twosidefalse
}

\DeclareOption{twoside}{
	\PassOptionsToClass{twoside}{memoir}
	\@twosidetrue
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

\ExecuteOptions{titlepage,oneside}
\ProcessOptions

\LoadClass[11pt]{memoir}

%%%% Required packages

\RequirePackage[usenames,dvipsnames]{xcolor}
\RequirePackage[includemp, left=3cm,right=1cm,top=3cm,bottom=2cm, marginparwidth=1.6cm, marginparsep=0.7cm]{geometry}
\RequirePackage[english]{babel}
\RequirePackage{mathpazo}
\RequirePackage{imakeidx}
\RequirePackage{titling}
\RequirePackage{lastpage}
\RequirePackage{amsthm}
\RequirePackage{framed}
\RequirePackage{mdframed}
\RequirePackage[pdfencoding=auto,psdextra]{hyperref}
\RequirePackage{exmath}
\RequirePackage{wrapfig}
\RequirePackage{MathUnicode}
\RequirePackage{calc}
\RequirePackage{listings}
\RequirePackage{setspace}
\RequirePackage{pdfpages}
\RequirePackage{datetime}
\RequirePackage{environ}
\RequirePackage{pgfkeys}
\RequirePackage{natbib}
\RequirePackage{enumitem}
\RequirePackage[some]{background}
\let\fref\relax
\RequirePackage[plain]{fancyref}
\RequirePackage{booktabs}

%% Some configurations and adjustements

% Caption setups
\captionsetup[figure]{font = {small, sf}, labelfont = {bf}}
\captionsetup[table]{font = {small, sf}, labelfont = {bf}}
\captionsetup[algorithm]{font = {small, sf}, labelfont = {bf}}

% List adjustments
\setlist{noitemsep}

% Fix links to the index
\let\oldindex\printindex
\def\printindex{\clearpage\phantomsection\oldindex}

\hypersetup{
	hyperindex,
    colorlinks,
    allcolors=blue!60!black
}

%%%% Page styling (footers and headers)
\pagestyle{ruled}

\def\titlefootstyle{\footnotesize}
\def\pagenumberstyle{\small}

% Footer for odd pages
\makeoddfoot{ruled}
	{\titlefootstyle\textit{\thetitle}}	% left
	{}									% center
	{\pagenumberstyle\thepage /\pageref{LastPage}} 	% right

% Same as above: left, center, right footers on even pages.
\makeevenfoot{ruled}
	{\pagenumberstyle\thepage /\pageref{LastPage}}
	{}
	{\titlefootstyle\textit{\thetitle}}

% Same, just with the headers.
\makeevenhead{ruled}
	{\sffamily\scshape\leftmark}
	{}
	{}

\makeoddhead{ruled}
	{}
	{}
	{\sffamily\small\rightmark}

% Put a horizontal line above the footers.
\makefootrule{ruled}{\textwidth}{0.7pt}{2pt}

% Set plain pagestyle for chapter pages.
\copypagestyle{chapter}{plain}

% Fix styling in chapter pages to add the footers.
\def\@fixchapterstyle{
	\makeoddfoot{chapter}
		{\titlefootstyle\textit{\thetitle}}	% left
		{}									% center
		{\pagenumberstyle\thepage /\pageref{LastPage}} 	% right

	\makefootrule{chapter}{\textwidth}{0.7pt}{2pt}
}

% Fix styling (footer, header) in frontmatter
\copypagestyle{frontmatterstyle}{plain}

\makeoddfoot{frontmatterstyle}{}{\pagenumberstyle\thepage}{}
\makeevenfoot{frontmatterstyle}{}{\pagenumberstyle\thepage}{}

% TOC fixes
\newlength{\extratocentriesskip}
\setlength{\extratocentriesskip}{2pt}

% No separation between chapters in the
% frontmatter (e.g., table of contents, list of
% figures/tables).
\setlength{\cftbeforechapterskip}{\extratocentriesskip}


\def\@mainmattertocsettings{
	\addtocontents{toc}{
		\setlength{\cftbeforechapterskip}{10pt}
	} % Restore separation between chapters in TOC.
	\addtocontents{toc}{
		\vspace{10pt}
	}	% Extra separation between frontmatter and mainmatter chapters in TOC.
}

% Patch \mainmatter to introduce fixes in chapter styling, toc and more.
\let\@internal@mainmatter\mainmatter
\def\mainmatter{
	\pagestyle{ruled}
	\@internal@mainmatter
	\@fixchapterstyle
	\@mainmattertocsettings
}

% Same with \backmatter, patch to fix ToC.
\let\@internal@backmatter\backmatter
\def\backmatter{
	\addtocontents{toc}{
		\vspace{10pt}
		\setlength{\cftbeforechapterskip}{\extratocentriesskip}
	}
	\@internal@backmatter
}

\if@twoside
	\let\clearsidepage\cleardoublepage
\else
	\let\clearsidepage\clearpage
\fi

\let\@internal@frontmatter\frontmatter
\def\frontmatter{
	\@internal@frontmatter
	\pagenumbering{Roman}
	\pagestyle{frontmatterstyle}
}

%% Chapter, section and similar configuration
\headstyles{memman}
\chapterstyle{ell}

\setsecheadstyle{\scshape\Large}
\setsubsecheadstyle{\sffamily\bfseries}
\setparaheadstyle{\sffamily\bfseries}

% Show subsections in the table of contents
\setsecnumdepth{subsubsection}
\setcounter{tocdepth}{3}

%%%% Titlepage preconfiguration %%%%

\definecolor{titlepagecolor}{HTML}{800007}

% Configurations for including the abstract in the title page
\def\@abstracttitle{Abstract}

\let\abstract\@undefined
\let\endabstract\@undefined
\newif\if@abstractset % Para ver si el usuario lo ha configurado o no.
\NewEnviron{abstract}{
	\global\@abstractsettrue		% Decimos que el abstract se ha usado.
	\global\let\@abstractbody\BODY	% Y nos lo guardamos.
}

\def\and{\!,\ }
\renewcommand{\author}[1]{\def\theauthor{#1}}

\newif\if@showsignature

%%%%% Title page %%%%%%

% Options for the title page
\pgfkeys{
	/apntstitle/.is family, /apntstitle,
	signature/.is choice,
	signature/true/.code = {\@showsignaturetrue},
	signature/false/.code = {\@showsignaturefalse},
	organization/.code = {\def\organization{#1}},
	default/.style = {signature = true, organization = EPFL} % Argumentos por defecto
}

\pgfkeys{/apntstitle, default}
\newcommand{\titlesetup}[1]{\pgfkeys{/apntstitle, #1}} % Procesamos argumentos

\newcommand{\fullpagetitle}{
	\begin{titlingpage}
	\thispagestyle{empty}
	\backgroundsetup{
		scale=1,
		angle=0,
		opacity=1,
		contents={
		\begin{tikzpicture}[remember picture,overlay]
			\fill[titlepagecolor] (-0.5\paperwidth, -0.5\paperheight) rectangle (-0.35\paperwidth, \paperheight);
			\fill[titlepagecolor] (-0.33\paperwidth, -0.5\paperheight) rectangle (-0.32\paperwidth, \paperheight);
			\fill[titlepagecolor] (-0.321\paperwidth, 0.1\paperheight) rectangle (0.5\paperwidth, 0.108\paperheight);
		\end{tikzpicture}}
	}
	\BgThispage
	\newgeometry{right=1.5cm,bottom=1.5cm}

	% Control the margin for both the abstract and the build date
	\def\@titlepage@innerleftmargin{\hspace{40pt}}

	% The title
	\hfill
	\begin{minipage}[b][0.25\paperheight][b]{0.5\textwidth}
		\textcolor{titlepagecolor}{%
			\begin{hyphenrules}{nohyphenation}%
				\begin{flushright}
					\huge{\textbf{\fontfamily{fla}\selectfont\thetitle}}
				\end{flushright}
			\end{hyphenrules}%
		}
	\end{minipage}

	% Horizontal space for abstract (left) and author/title
	\vspace{50pt}
	\@titlepage@innerleftmargin
	\begin{minipage}[t]{0.4\linewidth}
		\if@abstractset % Write the abstract only if configured
			\setlength{\parskip}{5pt}
			\setlength{\parindent}{0pt}
			\sffamily\textbf{\@abstracttitle}\par
			\small\normalfont\@abstractbody
		\else
			\hfill
		\fi
	\end{minipage}
	\hfill
	\begin{minipage}[t]{0.4\linewidth}
		\begin{flushright}
			\vspace{1ex}
			\sffamily
			\def\and{\\} % New line for each one of the authors
			{\large\theauthor}\par
			\vspace{10pt}
			\small\thedate
			\noindent{%
				\ifthenelse{\equal{\organization}{}}{}{\\ \organization}%
			}
		\end{flushright}
	\end{minipage}

	\vfill
	\@titlepage@innerleftmargin
	\begin{minipage}[b]{0.2\textwidth}
		\titlepagebuilddate % Include the build date. Disabled via class option
	\end{minipage}
	\hfill\includegraphics[width = 100pt]{EPFLLogo.eps}
	\end{titlingpage}
}

\let\maketitle\fullpagetitle

\setlength{\parskip}{2mm}
\setlength{\headheight}{15pt}

\makeindex
