package test

import (
	"path/filepath"
	"testing"

	"github.com/Workiva/frugal/compiler"
)

func TestHTML(t *testing.T) {
	options := compiler.Options{
		File:    frugalGenFile,
		Gen:     "html",
		Out:     outputDir,
		Delim:   delim,
		Recurse: true,
	}
	if err := compiler.Compile(options); err != nil {
		t.Fatal("Unexpected error", err)
	}

	files := []FileComparisonPair{
		{"expected/html/style.css", filepath.Join(outputDir, "style.css")},
		{"expected/html/index.html", filepath.Join(outputDir, "index.html")},
		{"expected/html/base.html", filepath.Join(outputDir, "base.html")},
		{"expected/html/variety.html", filepath.Join(outputDir, "variety.html")},
	}

	copyAllFiles(t, files)
	compareAllFiles(t, files)
}

func TestHTMLStandalone(t *testing.T) {
	options := compiler.Options{
		File:    frugalGenFile,
		Gen:     "html:standalone",
		Out:     outputDir,
		Delim:   delim,
		Recurse: true,
	}
	if err := compiler.Compile(options); err != nil {
		t.Fatal("Unexpected error", err)
	}

	files := []FileComparisonPair{
		{"expected/html/standalone/index.html", filepath.Join(outputDir, "index.html")},
		{"expected/html/standalone/base.html", filepath.Join(outputDir, "base.html")},
		{"expected/html/standalone/variety.html", filepath.Join(outputDir, "variety.html")},
	}

	copyAllFiles(t, files)
	compareAllFiles(t, files)
}
