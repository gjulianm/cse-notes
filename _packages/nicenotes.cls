\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nicenotes}[2013/04/20 Note taking class]

\def\printbuilddate{\footnotetext{\tiny Documento compilado el \today\ a las \currenttime}}
\def\enableindexbuilddate{\renewcommand{\compdate}{\tiny{\today\, \currenttime}}}
\def\titlepagebuilddate{\par \vspace{3pt} \tiny \today\, \currenttime \vspace{-4pt}}
\newif\if@apuntestitlepage
\newif\if@shortheader
\@shortheaderfalse
\newcommand{\organization}{EPFL}

\DeclareOption{nobuilddate}{%
	\def\printbuilddate{}%
	\def\enableindexbuilddate{}%
	\def\titlepagebuilddate{}%
}

\DeclareOption{titlepage}{
	\@apuntestitlepagetrue
	\PassOptionsToClass{\CurrentOption}{custombase}
}

\DeclareOption{notitlepage}{
	\@apuntestitlepagefalse
	\PassOptionsToClass{\CurrentOption}{custombase}
}

\DeclareOption{shortheader}{
	\@shortheadertrue
}

\DeclareOption{bibnumbers}{\PassOptionsToPackage{numbers}{natbib}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{custombase}}

\ExecuteOptions{titlepage}
\ProcessOptions

\LoadClass{custombase}

\RequirePackage{setspace}
\RequirePackage{pdfpages}
\RequirePackage{datetime}
\RequirePackage{environ}
\RequirePackage{pgfkeys}
\RequirePackage{natbib}
\RequirePackage[nottoc]{tocbibind}% bibliografía y el índice no aparecen en el índice del pdf sin esta línea mágica. No sabemos qué hace, pero será mejor que tengas un buen motivo para quitarla
\RequirePackage[some]{background}

% Hacemos que el enlace al índice funcione bien.
\let\oldindex\printindex
\def\printindex{\clearpage\phantomsection\oldindex} % Simplemente hacemos que \printindex inserte un marcador de sección que se pueda enlazar

\if@removechapters
	\numberwithin{equation}{section}
\fi

%%%% Página de título superguay.

\definecolor{titlepagecolor}{HTML}{800007}

% Esto nos viene bien por si luego queremos
% reemplazar el título (en traducciones por ejemplo).
\def\@abstracttitle{Resumen}

% Incluimos el abstract (resumen)

% Primero eliminamos la definición del entorno abstract, si es que está.
% (si usamos \renewenvironment peta en algún caso extraño).
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

% Preparamos las opciones
\pgfkeys{
	/apntstitle/.is family, /apntstitle,
	signature/.is choice,
	signature/true/.code = {\@showsignaturetrue},
	signature/false/.code = {\@showsignaturefalse},
	organization/.code = {\def\organization{#1}},
	default/.style = {signature = true, organization = EPFL} % Argumentos por defecto
}

% Ejecutamos los argumentos por defecto por si el usuario no pone
% \titlesetup en el documento
\pgfkeys{/apntstitle, default}

% Hay que hacer esta chapuza de pasar los argumentos a \maketitle antes con
% \titlesetup porque por alguna razón no puedo redefinir \maketitle con argumentos
% opcionales.
\newcommand{\titlesetup}[1]{\pgfkeys{/apntstitle, #1}} % Procesamos argumentos

\newcommand{\fullpagetitle}{
\begin{titlepage}
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

% The title
\hfill
\begin{minipage}[b][0.25\paperheight][b]{0.5\textwidth}
	\textcolor{titlepagecolor}{%
		\begin{hyphenrules}{nohyphenation}%
			\begin{spacing}{1}
				\huge{\textbf{\fontfamily{fla}\selectfont\thetitle}}
			\end{spacing}
		\end{hyphenrules}%
	}
\end{minipage}

\vspace{20pt}
\begin{flushright}
	\fontfamily{fla}\selectfont
	\def\and{\\} % New line for each one of the authors
	{\large\theauthor}\par
	\vspace{10pt}
	\small\thedate
	\noindent{%
		\ifthenelse{\equal{\organization}{}}{}{\\ \organization}%
	}
	% In case we want the build date
	\titlepagebuilddate
\end{flushright}

\vfill
\hfill\includegraphics[width = 100pt]{EPFLLogo.eps}
\end{titlepage}
}
\if@apuntestitlepage % Nos piden la página de título, así que renovamos el comando \maketitle.
\let\maketitle\fullpagetitle
\fi

\newcommand{\compdate}{}

% Cabecera super molona
\fancyhf{}
\PrerenderUnicode{ÁáÉéÍíÓóÚúÑñ} % Para que salgan las tildes y demás mierdas en el título.
\fancypagestyle{plain}{%
	\if@shortheader
		\lhead{\small \itshape \thetitle}
	\else
		\lhead{%
			\small \itshape \thetitle\, -\, \thedate\,%
			\ifthenelse{\equal{\organization}{}}{}{ -\, \organization}%
		}
	\fi
	\rhead{\small \theauthor}
	\cfoot{\thepage\ de \pageref{LastPage}}
	\rfoot{\compdate}
}

\setlength{\parskip}{2mm}
\setlength{\headheight}{15pt}

\apptocmd{\printindex}{\enableindexbuilddate}{}{}
\apptocmd{\maketitle}{\printbuilddate}{}{}

\newcommand{\placeholder}[1]{\begin{framed}\textit{\textbf{A rellenar:} #1}\end{framed}}

\makeindex
