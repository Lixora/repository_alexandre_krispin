;; tei-html-docs-p4.el -- Show TEI guidelines for current element
;;
;; Copyright (C) 2004-5 P J Heslin
;;
;; Author: Peter Heslin <p.j.heslin@dur.ac.uk>
;; URL: http://www.dur.ac.uk/p.j.heslin/Software/Emacs/Download/tei-html-docs-p4.el
;; Version: 1.0
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; If you do not have a copy of the GNU General Public License, you
;; can obtain one by writing to the Free Software Foundation, Inc., 59
;; Temple Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;; A quick but useful hack for TEI-P4 XML documents: it provides a
;; function that looks up the name of the element before point and
;; displays the TEI guidelines for that element.
;;
;; You need to download and unzip the HTML documentation from
;; http://www.tei-c.org/Guidelines2/p4html.tar.gz.  Then set the
;; variable tei-html-docs-p4-dir to the directory with all of the
;; ref-*.html files you just unzipped, like so:
;;
;;    (setq tei-html-docs-p4-dir "~/TEI_P4/")
;;
;; If you don't set tei-html-docs-p4-dir, then the on-line version of the
;; docs on the TEI web-site will be used instead.
;;
;; In order of preference, the docs will be viewed with emacs-w3m
;; (http://emacs-w3m.namazu.org/), which requires w3m (apt-get w3m or
;; see http://w3m.sourceforge.net/), or with w3, a browser written in
;; Emacs Lisp (see http://www.gnu.org/software/w3/ for the CVS
;; version, which handles nested tables, as required here); finally,
;; if neither of these are available, an external web browser will
;; be launched.
;;
;; Then put this package somewhere in your load-path, require it, and
;; assign the function tei-html-docs-p4-element-at-point to a
;; key-binding, with lines like these in your .emacs (this example
;; assumes you use nxml-mode to edit TEI documents):
;;
;;    (require 'tei-html-docs-p4)
;;    (define-key nxml-mode-map (kbd "<S-f1>") 'tei-html-docs-p4-element-at-point)

;;; Code:

(defvar tei-html-docs-p4-dir nil
  "Directory containing the TEI P4 documentation in HTML format,
  unzipped from http://www.tei-c.org/Guidelines2/p4html.tar.gz.
  Make sure it ends in a /.  If NIL, use the on-line version.")

(defvar tei-html-docs-p4-url "http://www.tei-c.org/P4X/")

(defvar tei-html-docs-p4-view-command 'browse-url
  "Command to use to view the TEI documentation")
(setq tei-html-docs-p4-view-command
      (cond ((fboundp 'w3m-goto-url) 'w3m-goto-url)
            ((fboundp 'w3-fetch) 'w3-fetch)
            (t 'browse-url)))

(defun tei-html-docs-p4-element-at-point ()
  (interactive)
  (save-excursion
    (if (and (re-search-backward "<[^!?/>]" nil t)
             (re-search-forward "\\=<\\([^!?/>][^ \t\r\n>]*\\)" nil t))
        (let ((file (cadr (assoc (match-string 1)
                                 tei-html-docs-p4-element-alist))))
          (if file
              (funcall tei-html-docs-p4-view-command
                       (if tei-html-docs-p4-dir
                           (concat "file://"
                                   (expand-file-name
                                    (concat tei-html-docs-p4-dir file)))
                         (concat tei-html-docs-p4-url file)))
            (message "%s" (concat "Error: element "
                                  (match-string 1) " not found in docs"))))
      (message "%s" "Error: no element found."))))
  

;; Almost all, but unfortunately not quite all of the files are of the
;; form ref-ELEMENT.html.  For some reason, some element names have
;; been munged slightly.  So instead of doing (concat "ref-" (upcase
;; (match-string 1)) ".html") we have to supply this messy list.  It
;; was generated with this command line:
;;
;; grep h1 ref-* | perl -ne 'print "(\"", m/&lt;(.*?)&gt;/, "\" \"", m/(ref-.*?html)/, "\")\n"'  | grep -v '^(""'

(defvar tei-html-docs-p4-element-alist 
  `(("abbr" "ref-ABBR.html")
    ("activity" "ref-ACTIVITY.html")
    ("actor" "ref-ACTOR.html")
    ("add" "ref-ADD.html")
    ("addName" "ref-ADDNAME.html")
    ("address" "ref-ADDRESS.html")
    ("addrLine" "ref-ADDRLINE.html")
    ("addSpan" "ref-ADDSPAN.html")
    ("admin" "ref-ADMIN.html")
    ("affiliation" "ref-AFFILIAT.html")
    ("altGrp" "ref-ALTGRP.html")
    ("alt" "ref-ALT.html")
    ("analytic" "ref-ANALYTIC.html")
    ("anchor" "ref-ANCHOR.html")
    ("ab" "ref-ANONB.html")
    ("any" "ref-ANY.html")
    ("app" "ref-APP.html")
    ("arc" "ref-ARC.html")
    ("argument" "ref-ARGUMENT.html")
    ("attDef" "ref-ATTDEF.html")
    ("att" "ref-ATT.html")
    ("attlDecl" "ref-ATTLDECL.html")
    ("attList" "ref-ATTLIST.html")
    ("attName" "ref-ATTNAME.html")
    ("author" "ref-AUTHOR.html")
    ("authority" "ref-AUTHORTY.html")
    ("availability" "ref-AVAIL.html")
    ("back" "ref-BACK.html")
    ("baseWsd" "ref-BASEWSD.html")
    ("biblFull" "ref-BIBLFULL.html")
    ("bibl" "ref-BIBL.html")
    ("biblScope" "ref-BIBLSCOP.html")
    ("biblStruct" "ref-BIBLSTRU.html")
    ("bicond" "ref-BICOND.html")
    ("birth" "ref-BIRTH.html")
    ("bloc" "ref-BLOC.html")
    ("body" "ref-BODY.html")
    ("broadcast" "ref-BROADCAS.html")
    ("byline" "ref-BYLINE.html")
    ("caesura" "ref-CAESURA.html")
    ("camera" "ref-CAMERA.html")
    ("caption" "ref-CAPTION.html")
    ("case" "ref-CASE.html")
    ("castGroup" "ref-CASTGRP.html")
    ("castItem" "ref-CASTITEM.html")
    ("castList" "ref-CASTLIST.html")
    ("catDesc" "ref-CATDESC.html")
    ("category" "ref-CATEGORY.html")
    ("catRef" "ref-CATREF.html")
    ("cell" "ref-CELL.html")
    ("certainty" "ref-CERTAIN.html")
    ("change" "ref-CHANGE.html")
    ("channel" "ref-CHANNEL.html")
    ("children" "ref-CHILDREN.html")
    ("c" "ref-C.html")
    ("cit" "ref-CIT.html")
    ("classDecl" "ref-CLASDECL.html")
    ("classCode" "ref-CLASSCOD.html")
    ("classDoc" "ref-CLASSDOC.html")
    ("classes" "ref-CLASSES.html")
    ("class" "ref-CLASS.html")
    ("cl" "ref-CL.html")
    ("closer" "ref-CLOSER.html")
    ("cb" "ref-COLBR.html")
    ("colloc" "ref-COLLOC.html")
    ("cond" "ref-COND.html")
    ("constitution" "ref-CONSTITN.html")
    ("correction" "ref-CORRECTN.html")
    ("corr" "ref-CORR.html")
    ("country" "ref-COUNTRY.html")
    ("creation" "ref-CREATN.html")
    ("damage" "ref-DAMAGE.html")
    ("dataDesc" "ref-DATADESC.html")
    ("datatype" "ref-DATATYPE.html")
    ("date" "ref-DATE.html")
    ("dateline" "ref-DATELINE.html")
    ("dateRange" "ref-DATERANG.html")
    ("dateStruct" "ref-DATESTRU.html")
    ("day" "ref-DAY.html")
    ("default" "ref-DEFAULT.html")
    ("def" "ref-DEF.html")
    ("del" "ref-DEL.html")
    ("delSpan" "ref-DELSPAN.html")
    ("derivation" "ref-DERIVATN.html")
    ("desc" "ref-DESC.html")
    ("descrip" "ref-DESCRIP.html")
    ("dft" "ref-DFT.html")
    ("dictScrap" "ref-DICSCRAP.html")
    ("eg" "ref-DIEG.html")
    ("direction" "ref-DIRECTN.html")
    ("distance" "ref-DISTANCE.html")
    ("distinct" "ref-DISTINCT.html")
    ("distributor" "ref-DISTRIB.html")
    ("div0" "ref-DIV0.html")
    ("div1" "ref-DIV1.html")
    ("div2" "ref-DIV2.html")
    ("div3" "ref-DIV3.html")
    ("div4" "ref-DIV4.html")
    ("div5" "ref-DIV5.html")
    ("div6" "ref-DIV6.html")
    ("div7" "ref-DIV7.html")
    ("divGen" "ref-DIVGEN.html")
    ("div" "ref-DIV.html")
    ("docAuthor" "ref-DOCAUTH.html")
    ("docDate" "ref-DOCDATE.html")
    ("docEdition" "ref-DOCEDITN.html")
    ("docImprint" "ref-DOCIMPRT.html")
    ("docTitle" "ref-DOCTITLE.html")
    ("domain" "ref-DOMAIN.html")
    ("role" "ref-DRROLE.html")
    ("editorialDecl" "ref-EDDECL.html")
    ("edition" "ref-EDITION.html")
    ("editor" "ref-EDITOR.html")
    ("editionStmt" "ref-EDSTMT.html")
    ("education" "ref-EDUCN.html")
    ("eLeaf" "ref-ELEAF.html")
    ("elemDecl" "ref-ELEMDECL.html")
    ("emph" "ref-EMPH.html")
    ("encodingDesc" "ref-ENCDESC.html")
    ("entDoc" "ref-ENTDOC.html")
    ("entName" "ref-ENTNAME.html")
    ("entryFree" "ref-ENTRYFR.html")
    ("entry" "ref-ENTRY.html")
    ("epigraph" "ref-EPIGRAPH.html")
    ("epilogue" "ref-EPILOGUE.html")
    ("equipment" "ref-EQUIPMEN.html")
    ("equiv" "ref-EQUIV.html")
    ("eTree" "ref-ETREE.html")
    ("etym" "ref-ETYM.html")
    ("event" "ref-EVENT.html")
    ("exceptions" "ref-EXCEPTNS.html")
    ("exemplum" "ref-EXEMPLUM.html")
    ("expan" "ref-EXPAN.html")
    ("extent" "ref-EXTENT.html")
    ("factuality" "ref-FACTUAL.html")
    ("fAlt" "ref-FALT.html")
    ("fDecl" "ref-FDECL.html")
    ("fDescr" "ref-FDESCR.html")
    ("f" "ref-F.html")
    ("figDesc" "ref-FIGDESC.html")
    ("figure" "ref-FIGURE.html")
    ("fileDesc" "ref-FILDESC.html")
    ("files" "ref-FILES.html")
    ("fLib" "ref-FLIB.html")
    ("foreign" "ref-FOREIGN.html")
    ("foreName" "ref-FORENAME.html")
    ("forestGrp" "ref-FORESTGP.html")
    ("forest" "ref-FOREST.html")
    ("form" "ref-FORM.html")
    ("formula" "ref-FORMULA.html")
    ("front" "ref-FRONT.html")
    ("firstLang" "ref-FRSTLANG.html")
    ("fsConstraints" "ref-FSCONSTR.html")
    ("fsdDecl" "ref-FSDDECL.html")
    ("fsDecl" "ref-FSDECL.html")
    ("fsDescr" "ref-FSDESCR.html")
    ("fsLib" "ref-FSLIB.html")
    ("fs" "ref-FSTAG.html")
    ("funder" "ref-FUNDER.html")
    ("fvLib" "ref-FVLIB.html")
    ("fw" "ref-FW.html")
    ("gap" "ref-GAP.html")
    ("gen" "ref-GEN.html")
    ("genName" "ref-GENNAME.html")
    ("geog" "ref-GEOG.html")
    ("geogName" "ref-GEOGNAME.html")
    ("gi" "ref-GI.html")
    ("gloss" "ref-GLOSS.html")
    ("gramGrp" "ref-GRAMGRP.html")
    ("gram" "ref-GRAM.html")
    ("graph" "ref-GRAPH.html")
    ("group" "ref-GROUP.html")
    ("hand" "ref-HAND.html")
    ("handList" "ref-HANDLIST.html")
    ("handShift" "ref-HANDSHFT.html")
    ("head" "ref-HEAD.html")
    ("headItem" "ref-HEADIT.html")
    ("headLabel" "ref-HEADLAB.html")
    ("hi" "ref-HI.html")
    ("hom" "ref-HOM.html")
    ("hour" "ref-HOUR.html")
    ("hyphenation" "ref-HYPHEN.html")
    ("hyph" "ref-HYPH.html")
    ("idno" "ref-IDNO.html")
    ("iff" "ref-IFF.html")
    ("if" "ref-IF.html")
    ("ihs" "ref-IHS.html")
    ("imprimatur" "ref-IMPRIMAT.html")
    ("imprint" "ref-IMPRINT.html")
    ("index" "ref-INDEX.html")
    ("iNode" "ref-INODE.html")
    ("interaction" "ref-INTERACT.html")
    ("interpGrp" "ref-INTERPGP.html")
    ("interp" "ref-INTERP.html")
    ("interpretation" "ref-INTERPTN.html")
    ("item" "ref-ITEM.html")
    ("itype" "ref-ITYPE.html")
    ("joinGrp" "ref-JOINGRP.html")
    ("join" "ref-JOIN.html")
    ("keywords" "ref-KEYWORDS.html")
    ("kinesic" "ref-KINESIC.html")
    ("label" "ref-LABEL.html")
    ("lacunaEnd" "ref-LACEND.html")
    ("lacunaStart" "ref-LACSTART.html")
    ("lang" "ref-LANG.html")
    ("langKnown" "ref-LANGKNOW.html")
    ("language" "ref-LANGUAGE.html")
    ("langUsage" "ref-LANGUSG.html")
    ("lbl" "ref-LBL.html")
    ("leaf" "ref-LEAF.html")
    ("lem" "ref-LEM.html")
    ("lg1" "ref-LG1.html")
    ("lg2" "ref-LG2.html")
    ("lg3" "ref-LG3.html")
    ("lg4" "ref-LG4.html")
    ("lg5" "ref-LG5.html")
    ("lg" "ref-LG.html")
    ("l" "ref-L.html")
    ("lb" "ref-LINEBR.html")
    ("linkGrp" "ref-LINKGRP.html")
    ("link" "ref-LINK.html")
    ("listBibl" "ref-LISTBIBL.html")
    ("list" "ref-LIST.html")
    ("locale" "ref-LOCALE.html")
    ("measure" "ref-MEASURE.html")
    ("meeting" "ref-MEETING.html")
    ("mentioned" "ref-MENTIOND.html")
    ("metDecl" "ref-METDECL.html")
    ("m" "ref-M.html")
    ("milestone" "ref-MILEST.html")
    ("minus" "ref-MINUS.html")
    ("minute" "ref-MINUTE.html")
    ("monogr" "ref-MONOGR.html")
    ("month" "ref-MONTH.html")
    ("mood" "ref-MOOD.html")
    ("move" "ref-MOVE.html")
    ("msr" "ref-MSR.html")
    ("name" "ref-NAME.html")
    ("nameLink" "ref-NAMELINK.html")
    ("nbr" "ref-NBR.html")
    ("node" "ref-NODE.html")
    ("none" "ref-NONE.html")
    ("normalization" "ref-NORMALZN.html")
    ("note" "ref-NOTE.html")
    ("notesStmt" "ref-NOTSTMT.html")
    ("null" "ref-NULL.html")
    ("number" "ref-NUMBER.html")
    ("num" "ref-NUM.html")
    ("occasion" "ref-OCCASION.html")
    ("occupation" "ref-OCCUPAT.html")
    ("offset" "ref-OFFSET.html")
    ("ofig" "ref-OFIG.html")
    ("opener" "ref-OPENER.html")
    ("oRef" "ref-OREF.html")
    ("orgDivn" "ref-ORGDIVN.html")
    ("orgName" "ref-ORGNAME.html")
    ("orgTitle" "ref-ORGTITLE.html")
    ("orgType" "ref-ORGTYPE.html")
    ("orig" "ref-ORIG.html")
    ("orth" "ref-ORTH.html")
    ("otherForm" "ref-OTHFORM.html")
    ("oVar" "ref-OVAR.html")
    ("pb" "ref-PAGEBR.html")
    ("parents" "ref-PARENTS.html")
    ("particDesc" "ref-PARTDESC.html")
    ("part" "ref-PART.html")
    ("particLinks" "ref-PARTIREL.html")
    ("pause" "ref-PAUSE.html")
    ("performance" "ref-PERFORM.html")
    ("per" "ref-PER.html")
    ("personGrp" "ref-PERSGRP.html")
    ("persName" "ref-PERSNAME.html")
    ("person" "ref-PERSON.html")
    ("phr" "ref-PHR.html")
    ("p" "ref-P.html")
    ("placeName" "ref-PLACNAME.html")
    ("col" "ref-PLCOL.html")
    ("line" "ref-PLLINE.html")
    ("page" "ref-PLPAGE.html")
    ("plus" "ref-PLUS.html")
    ("vol" "ref-PLVOL.html")
    ("pos" "ref-POS.html")
    ("postBox" "ref-POSTBOX.html")
    ("postCode" "ref-POSTCODE.html")
    ("pRef" "ref-PREF.html")
    ("preparedness" "ref-PREPNESS.html")
    ("principal" "ref-PRINCIPL.html")
    ("profileDesc" "ref-PROFDESC.html")
    ("projectDesc" "ref-PROJDESC.html")
    ("prologue" "ref-PROLOGUE.html")
    ("pron" "ref-PRON.html")
    ("ptr" "ref-PTR.html")
    ("publisher" "ref-PUBLISHR.html")
    ("pubPlace" "ref-PUBPLACE.html")
    ("publicationStmt" "ref-PUBSTMT.html")
    ("purpose" "ref-PURPOSE.html")
    ("pVar" "ref-PVAR.html")
    ("q" "ref-Q.html")
    ("quote" "ref-QUOTE.html")
    ("quotation" "ref-QUOTN.html")
    ("rate" "ref-RATE.html")
    ("rdgGrp" "ref-RDGGRP.html")
    ("rdg" "ref-RDG.html")
    ("recording" "ref-RECORDIN.html")
    ("recordingStmt" "ref-RECSTMT.html")
    ("ref" "ref-REF.html")
    ("refsDecl" "ref-REFSDECL.html")
    ("reg" "ref-REG.html")
    ("region" "ref-REGION.html")
    ("re" "ref-RE.html")
    ("relation" "ref-RELATION.html")
    ("remarks" "ref-REMARKS.html")
    ("rendition" "ref-RENDITN.html")
    ("residence" "ref-RESIDENC.html")
    ("respStmt" "ref-RESP.html")
    ("respons" "ref-RESPONS.html")
    ("restore" "ref-RESTORE.html")
    ("revisionDesc" "ref-REVDESC.html")
    ("roleDesc" "ref-ROLEDESC.html")
    ("resp" "ref-ROLE.html")
    ("roleName" "ref-ROLENAME.html")
    ("root" "ref-ROOT.html")
    ("row" "ref-ROW.html")
    ("rs" "ref-RS.html")
    ("salute" "ref-SALUTE.html")
    ("samplingDecl" "ref-SAMPDECL.html")
    ("script" "ref-SCRIPT.html")
    ("scriptStmt" "ref-SCRSTMT.html")
    ("second" "ref-SECOND.html")
    ("seg" "ref-SEG.html")
    ("segmentation" "ref-SEGMENTN.html")
    ("sense" "ref-SENSE.html")
    ("series" "ref-SERIES.html")
    ("seriesStmt" "ref-SERSTMT.html")
    ("set" "ref-SET.html")
    ("settingDesc" "ref-SETTDESC.html")
    ("setting" "ref-SETTING.html")
    ("settlement" "ref-SETTLE.html")
    ("shift" "ref-SHIFT.html")
    ("s" "ref-S.html")
    ("sic" "ref-SIC.html")
    ("signed" "ref-SIGNED.html")
    ("soCalled" "ref-SOCALLED.html")
    ("socecStatus" "ref-SOCECSTA.html")
    ("sound" "ref-SOUND.html")
    ("sourceDesc" "ref-SOUSTMT.html")
    ("space" "ref-SPACE.html")
    ("spanGrp" "ref-SPANGRP.html")
    ("span" "ref-SPAN.html")
    ("speaker" "ref-SPEAKER.html")
    ("sp" "ref-SP.html")
    ("sponsor" "ref-SPONSOR.html")
    ("stage" "ref-STAGE.html")
    ("state" "ref-STATE.html")
    ("stdVals" "ref-STDVALS.html")
    ("step" "ref-STEP.html")
    ("street" "ref-STREET.html")
    ("stress" "ref-STRESS.html")
    ("str" "ref-STR.html")
    ("string" "ref-STRING.html")
    ("subc" "ref-SUBC.html")
    ("superEntry" "ref-SUPENTRY.html")
    ("supplied" "ref-SUPPLIED.html")
    ("surname" "ref-SURNAME.html")
    ("syll" "ref-SYLL.html")
    ("symbol" "ref-SYMBOL.html")
    ("sym" "ref-SYM.html")
    ("table" "ref-TABLE.html")
    ("tagDoc" "ref-TAGDOC.html")
    ("tag" "ref-TAG.html")
    ("tagsDecl" "ref-TAGSDECL.html")
    ("tagUsage" "ref-TAGUSAGE.html")
    ("taxonomy" "ref-TAXONOMY.html")
    ("eg" "ref-TDEG.html")
    ("tech" "ref-TECH.html")
    ("TEI.2" "ref-TEI2.html")
    ("teiCorpus.2" "ref-TEICORP2.html")
    ("teiFsd2" "ref-TEIFSD2.html")
    ("teiHeader" "ref-TEIHEAD.html")
    ("writingSystemDeclaration" "ref-TEIWSD.html")
    ("termEntry" "ref-TERMENTF.html")
    ("termEntry" "ref-TERMENTN.html")
    ("term" "ref-TERM.html")
    ("textClass" "ref-TEXTCLAS.html")
    ("textDesc" "ref-TEXTDESC.html")
    ("text" "ref-TEXT.html")
    ("then" "ref-THEN.html")
    ("tig" "ref-TIG.html")
    ("time" "ref-TIME.html")
    ("timeline" "ref-TIMELINE.html")
    ("timeRange" "ref-TIMERANG.html")
    ("timeStruct" "ref-TIMESTRU.html")
    ("title" "ref-TITLE.html")
    ("titlePage" "ref-TITLEPA.html")
    ("titlePart" "ref-TITLEPT.html")
    ("titleStmt" "ref-TITSTMT.html")
    ("tns" "ref-TNS.html")
    ("trailer" "ref-TRAILER.html")
    ("trans" "ref-TRANS.html")
    ("tree" "ref-TREE.html")
    ("tr" "ref-TR.html")
    ("triangle" "ref-TRIANGLE.html")
    ("tsd" "ref-TSD.html")
    ("u" "ref-U.html")
    ("uncertain" "ref-UNCERT.html")
    ("unclear" "ref-UNCLEAR.html")
    ("usg" "ref-USG.html")
    ("valDesc" "ref-VALDESC.html")
    ("val" "ref-VAL.html")
    ("valList" "ref-VALLIST.html")
    ("vAlt" "ref-VALT.html")
    ("variantEncoding" "ref-VARENCOD.html")
    ("vDefault" "ref-VDFT.html")
    ("%version;" "ref-VERNAME.html")
    ("view" "ref-VIEW.html")
    ("vocal" "ref-VOCAL.html")
    ("vRange" "ref-VRANGE.html")
    ("week" "ref-WEEK.html")
    ("when" "ref-WHEN.html")
    ("w" "ref-W.html")
    ("witDetail" "ref-WITDTL.html")
    ("witEnd" "ref-WITEND.html")
    ("wit" "ref-WIT.html")
    ("witList" "ref-WITLIST.html")
    ("witness" "ref-WITNESS.html")
    ("witStart" "ref-WITSTART.html")
    ("writing" "ref-WRITING.html")
    ("codedCharSet" "ref-WSDCCS.html")
    ("character" "ref-WSDCHAR.html")
    ("characters" "ref-WSDCHARS.html")
    ("desc" "ref-WSDDESC.html")
    ("entitySet" "ref-WSDENTS.html")
    ("figure" "ref-WSDFIG.html")
    ("form" "ref-WSDFORM.html")
    ("language" "ref-WSDLANG.html")
    ("note" "ref-WSDNOTE.html")
    ("extFigure" "ref-WSDXFIG.html")
    ("xptr" "ref-XPTR.html")
    ("xref" "ref-XREF.html")
    ("xr" "ref-XR.html")
    ("year" "ref-YEAR.html"))
  "Translate element names to doc files.")

(provide 'tei-html-docs-p4)
