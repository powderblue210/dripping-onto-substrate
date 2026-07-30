// -------------------------------------------------------------
// ImageJ Macro: Batch Boundary Detector & CSV Exporter for DoS
// -------------------------------------------------------------

inputDir = getDirectory("Select Source Directory");
outputDir = getDirectory("Select Output Directory");

thresholdVal = 90;      // Threshold (Can be adjusted)
dt = 0.125;             // Frame interval in milliseconds (Can be adjusted)
setBatchMode(true);    

// Output Folder Path
outPath = outputDir + File.separator;
run("Clear Results");

// Input Foler Path
list = getFileList(inputDir);
Array.sort(list); // Image File should be Lexicographical Sorted (ex. 001, 002, ... 999)

frameCount = 0;
rowIndex = 0;

for (i = 0; i < list.length; i++) {
    // Image Files only (ex. tif, png, jpg, bmp)
    if (endsWith(toLowerCase(list[i]), ".tif") || endsWith(toLowerCase(list[i]), ".png") || 
        endsWith(toLowerCase(list[i]), ".jpg") || endsWith(toLowerCase(list[i]), ".jpeg") || 
        endsWith(toLowerCase(list[i]), ".bmp")) {
        
        open(inputDir + File.separator + list[i]);
        frameCount++;
        
        w = getWidth();
        h = getHeight();

        // Calculating R0
        y_R0 = 4;
        makeLine(0, y_R0, w, y_R0);
        profile_R0 = getProfile();

        x_left_R0 = -1;
        x_right_R0 = -1;

        for (x = 2; x < profile_R0.length - 2; x++) {
            if (profile_R0[x] <= thresholdVal) {
                x_left_R0 = x;
                break;
            }
        }

        start_x_R0 = profile_R0.length - 5; 
        end_x_R0 = 0;
        if (x_left_R0 != -1) {
            end_x_R0 = x_left_R0 + 1;
        }

        for (x = start_x_R0; x > end_x_R0; x--) {
            if (profile_R0[x] <= thresholdVal) {
                x_right_R0 = x;
                break;
            }
        }

        R0 = -1;
        if (x_left_R0 != -1 && x_right_R0 != -1 && x_right_R0 > x_left_R0) {
            R0 = (x_right_R0 - x_left_R0) / 2.0;
        }
    
        // Calculating R(t)
        y_start = Math.round(h * 0.25);
        y_end   = Math.round(h * 0.75);

        run("RGB Color");

        minWidth = 999999;
        bestY = -1;
        bestXLeft = -1;
        bestXRight = -1;

        hasBreakup = false; // Filament Breakup flag (true if filament breaks up)

        for (y = y_start; y <= y_end; y++) {
            makeLine(0, y, w, y);
            profile = getProfile();
            
            x_left = -1;
            x_right = -1;
            
            // Scanning Left Boundary
            for (x = 2; x < profile.length - 2; x++) {
                if (profile[x] <= thresholdVal) {
                    x_left = x;
                    break;
                }
            }
            
            // Scanning Right Boundary
            start_x = profile.length - 5; 
            
            end_x = 0;
            if (x_left != -1) {
                end_x = x_left + 1;
            }
            
            for (x = start_x; x > end_x; x--) {
                if (profile[x] <= thresholdVal) {
                    x_right = x;
                    break;
                }
            }
            
            // No Boundary = Filament Breakup
            if (x_left != -1 && x_right != -1 && x_right > x_left) {
            
                setColor(255, 0, 0); drawRect(x_left, y, 1, 1);  // Left Boundary: Red
                setColor(0, 0, 255); drawRect(x_right, y, 1, 1); // Right Boundary: Blue
                
                lineWidth = x_right - x_left;
                if (lineWidth < minWidth) {
                    minWidth = lineWidth;
                    bestY = y;
                    bestXLeft = x_left;
                    bestXRight = x_right;
                }
            } else {
                // Filament Breakup
                hasBreakup = true;
            }
        }

        R = 0;
        R_over_R0 = 0;

        // Filament Breakup
        if (!hasBreakup && bestY != -1) {
            setColor(0, 255, 0);
            drawLine(bestXLeft, bestY, bestXRight, bestY);
            
            R = minWidth / 2.0;
            if (R0 > 0) {
                R_over_R0 = R / R0;
            }
        } else {
            R = 0;
            R_over_R0 = 0;
        }

        run("Select None");

        // Generating csv file
        setResult("Frame", rowIndex, frameCount);
        setResult("FileName", rowIndex, list[i]); 
        setResult("Time_ms", rowIndex, (frameCount - 1) * dt);
        setResult("R_pixel", rowIndex, R);
        setResult("R0_pixel", rowIndex, R0);
        setResult("R/R0", rowIndex, R_over_R0);
        rowIndex++;

        // Analyzed Image
        saveAs("Png", outPath + "result_" + list[i]);
        close();
    }
}

// Save csv file
updateResults();
saveAs("Results", outPath + "filament_analysis_results.csv");

setBatchMode(false);
print("=== Batch Analysis Complete ===");
print("Processed Images: " + frameCount);
print("Results Saved To: " + outPath);