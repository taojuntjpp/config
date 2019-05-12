//调用[Folder]的[selectDialog]命令，弹出文件夹选择窗口，提示用户选择待处理文件所在的文件夹。
//并将文件夹存储在变量[inputFolder]中。
var inputFolder = Folder.selectDialog("请选择图片所在文件夹：");

var outputFolder = Folder.selectDialog("请选择图片另存所在文件夹：");



//判断如果文件夹存在，则执行后面的代码。
if (inputFolder != null && inputFolder != null) 
{

    // 打开水印图片
    var logoFile = open(File('/Users/anan/Pictures/logo.png'));
    app.activeDocument = logoFile;
    width = logoFile.width;
    height = logoFile.height;
    logoFile.activeLayer.copy();

    //alert(logoFile.width.value);
    //alert(logoFile.width);

    var jpegOptions = new JPEGSaveOptions();
    var regex = /\(([^)]*)\)/;

    
    var dirList = inputFolder.getFiles('*');

    for (var ii = 0; ii < dirList.length; ii++) {

        
        var innerFolder = Folder(dirList[ii]);

        if (innerFolder.hidden) {
            continue;
        }

        

        //定义一个变量[fileList]，获得文件夹下的所有图片。
        var fileList = innerFolder.getFiles('*.jpg');

        var count = fileList.length;
        var prefix = parseInt(innerFolder.name) + '-';


        //添加一个循环语句，遍历文件夹下所有图片。
        for (var i = 0; i < count; i++)
        {

            //判断如果图片是正常文件，并且处于非隐藏状态，则执行后面的动作。
            if (fileList[i] instanceof File && fileList[i].hidden == false) 
            {
                                
                //打开遍历到的图片。
                var docRef = open(fileList[i]);
                app.activeDocument = docRef;
                docRef.resizeImage('800px', '800px');
                docRef.selection.selectAll();

                docRef.paste(true);

                docRef.flatten();
                docRef.bitsPerChannel = BitsPerChannelType.EIGHT;

                var filename = docRef.name;
                var result = filename.match(regex);

                if (result.length > 1) {
                   filename =  result[1] + '.jpg';   
                }
                
                
                docRef.saveAs(new File(outputFolder + '/' + prefix + filename), jpegOptions, true);
                // docRef.saveAs(new File(outputFolder + '/' + prefix + docRef.name), jpegOptions, true);

                //操作完成后，关闭文档。
                docRef.close(SaveOptions.DONOTSAVECHANGES);
            }
        }
    }

 }
 
