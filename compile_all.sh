#!/bin/bash

# Script to compile all .tex files and convert to PNG
# Usage: ./compile_all.sh

# Create fig directory if it doesn't exist
mkdir -p fig

# Find all .tex files in current directory
for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        filename="${tex_file%.tex}"
        echo "Processing $tex_file..."
        
        # Compile tex to PDF
        pdflatex "$tex_file"
        
        # Check if PDF was created successfully
        if [ -f "${filename}.pdf" ]; then
            echo "  ✓ PDF created: ${filename}.pdf"
            
            # Convert PDF to PNG with high resolution
            pdftoppm -png -r 300 "${filename}.pdf" "fig/${filename}"
            
            # Rename the output file to remove page number suffix
            if [ -f "fig/${filename}-1.png" ]; then
                mv "fig/${filename}-1.png" "fig/${filename}.png"
                echo "  ✓ PNG created: fig/${filename}.png"
            else
                echo "  ✗ Failed to create PNG for ${filename}"
            fi
        else
            echo "  ✗ Failed to create PDF for ${filename}"
        fi
    fi
done

# Clean up auxiliary files
echo "Cleaning up auxiliary files..."
rm -f *.aux *.log *.fls *.fdb_latexmk *.synctex.gz

echo "Done!"