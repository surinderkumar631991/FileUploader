$(document).ready(function () {
    var filenames = '';
    var _extension = $(".setExtensions_").val();
    var _size = $(".setSize_").val();
    var _extensions = _extension.split(",");
    // enable fileuploader plugin
    $('input[name="files"]').fileuploader({
        changeInput: '<div class="fileuploader-input">' +
        '<div class="fileuploader-input-inner">' +
        '<img src="/fileuploader/examples/drag-drop/images/fileuploader-dragdrop-icon.png">' +
        '<h3 class="fileuploader-input-caption"><span>Drag and drop files here</span></h3>' +
        '<p>or</p>' +
        '<div class="fileuploader-input-button"><span>Browse Files</span></div>' +
        '</div>' +
        '</div>',
        theme: 'dragdrop',
        upload: {
            url: 'FileUploadHandler.ashx',
            data: null,
            type: 'POST',
            enctype: 'multipart/form-data',
            start: true,
            synchron: true,
            beforeSend: function (item) {
                $.loadingBlockShow({
                    imgPath: 'SpinnerLoaderWithText/assets/img/default.svg',
                    imgStyle: {
                        width: 'auto',
                        textAlign: 'center',
                        marginTop: '20%'
                    },
                    text: "Saving your files...Please Wait"
                });
                _ext = item.extension;
                size = item.size / 1000;
                if (_extensions.indexOf("." + _ext) == -1 || (size > parseFloat(_size))) {
                    if (_extensions.indexOf("." + _ext) == -1) {
                        bootbox.alert({
                            message: "Please select only " + _extension + " files.",
                            size: 'medium'
                        });
                        $.loadingBlockHide();
                    }
                    else {
                        bootbox.alert({
                            message: "Files size must be less than " + _size + " Kb.",
                            size: 'small'
                        });
                        $.loadingBlockHide();
                    }

                    item.remove();
                    return false;
                }


            },
            //async: true,
            onSuccess: function (result1, item) {
                filenames += item.file.name + ",";
                $(".hiddenFileNames").val(filenames);
                var data = JSON.parse(result1);
                console.log(data);
                $("#analyseResult").css("display", "none");
                // if success
                if (data.isSuccess && data.files[0]) {
                    item.name = data.files[0].name;
                    item.html.find('.column-title > div:first-child').text(data.files[0].name).attr('title', data.files[0].name);
                }
                // if warnings
                if (data.hasWarnings) {
                    bootbox.alert({
                        message: data.warnings,
                        size: 'small'
                    });

                    item.html.removeClass('upload-successful').addClass('upload-failed');
                    // go out from success function by calling onError function
                    // in this case we have a animation there
                    // you can also response in PHP with 404
                    item.remove();
                    //return null;
                    $.loadingBlockHide();
                    return this.onError ? this.onError(item) : null;
                }

                item.html.find('.column-actions').append('<a class="fileuploader-action fileuploader-action-remove fileuploader-action-success" title="Remove"><i></i></a>');
                setTimeout(function () {
                    item.html.find('.progress-bar2').fadeOut(400);
                }, 400);
                $("#continueBtn").css("display", "block");
                $.loadingBlockHide();
            },
            onError: function (item) {
                var progressBar = item.html.find('.progress-bar2');

                if (progressBar.length > 0) {
                    progressBar.find('span').html(0 + "%");
                    progressBar.find('.fileuploader-progressbar .bar').width(0 + "%");
                    item.html.find('.progress-bar2').fadeOut(400);
                }

                item.upload.status != 'cancelled' && item.html.find('.fileuploader-action-retry').length == 0 ? item.html.find('.column-actions').prepend(
                    '<a class="fileuploader-action fileuploader-action-retry" title="Retry"><i></i></a>'
                ) : null;
            },
            onProgress: function (data, item) {
                var progressBar = item.html.find('.progress-bar2');

                if (progressBar.length > 0) {
                    progressBar.show();
                    progressBar.find('span').html(data.percentage + "%");
                    progressBar.find('.fileuploader-progressbar .bar').width(data.percentage + "%");
                }
            },
            onComplete: null,
        },
        onRemove: function (item) {
           
            $.post('RemoveFileHandler.ashx?file=' + item.name, {
                file: item.name
            });
        },

        captions: {
            feedback: 'Drag and drop files here',
            feedback2: 'Drag and drop files here',
            drop: 'Drag and drop files here'
        },
    });

});













//$(document).ready(function () {
//    var _extension = $(".setExtensions_").val();
//    var _size = $(".setSize_").val();
//    var _extensions = _extension.split(",");
//    // enable fileuploader plugin
//    $('input[name="files"]').fileuploader({
//        changeInput: '<div class="fileuploader-input">' +
//        '<div class="fileuploader-input-inner">' +
//        '<img src="/fileuploader/examples/drag-drop/images/fileuploader-dragdrop-icon.png">' +
//        '<h3 class="fileuploader-input-caption"><span>Drag and drop files here</span></h3>' +
//        '<p>or</p>' +
//        '<div class="fileuploader-input-button"><span>Browse Files</span></div>' +
//        '</div>' +
//        '</div>',
//        theme: 'dragdrop',
//        upload: {
//            url: 'FileUploadHandler.ashx',
//            data: null,
//            type: 'POST',
//            enctype: 'multipart/form-data',
//            start: true,
//            synchron: true,
//            beforeSend: function (item) {
//                $("#analyseResult").css("display", "none");
//                //$(".square").ploading({
//                //    action: 'show',
//                //    spinner: 'wave'
//                //});
//                $.loadingBlockShow({
//                    imgPath: 'SpinnerLoaderWithText/assets/img/default.svg',
//                    imgStyle: {
//                        width: 'auto',
//                        textAlign: 'center',
//                        marginTop: '20%'
//                    },
//                    text: "Please wait while we're analysing your files......"
//                });

//                _ext = item.extension;
//                size = item.size / 1000;
//                if (_extensions.indexOf("." + _ext) == -1 || (size >parseFloat(_size) )) {
//                    if (_extensions.indexOf("." +_ext) == -1) {
//                        bootbox.alert({
//                            message: "Please select only " + _extension + " files.",
//                            size: 'medium'
//                        });

//                        //$(".square").ploading({
//                        //    action: 'hide'
//                        //});
//                        $.loadingBlockHide();
//                    }
//                    else {
//                        bootbox.alert({
//                            message: "Files size must be less than " + _size + " Kb.",
//                            size: 'small'
//                        });

//                        //$(".square").ploading({
//                        //    action: 'hide'
//                        //});
//                        $.loadingBlockHide();
//                    }

//                    item.remove();
//                    return false;
//                }
                
             
//            },
//            async: true,
//            onSuccess: function (result1, item) {
                
//                var data = JSON.parse(result1);
//                console.log(data);

//                var result = JSON.parse(data.result);
//                console.log(result);
//                if (result != null && result != "" && result != undefined) {
//                    var res = "<h3>"+ item.file.name + " Result :</h3><br><table style='width:100%;'><tr style='background-color:#f1e1e1;'><td><b>Character :</b><br>Number : <br> ContextMatch : " + result.Character.Number[0].ContextMatch + "<br>" +
//                        "NoMatch : " + result.Character.Number[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Character.Number[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Character.Number[0].Repetitions + "<br>" +
//                        "Total : " + result.Character.Number[0].Total + "</td>" +
//                        "<td> <br>Percentage : <br> ContextMatch : " + result.Character.Percentage[0].ContextMatch + "<br>" +
//                        "NoMatch : " + result.Character.Percentage[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Character.Percentage[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Character.Percentage[0].Repetitions + "<br>" +
//                        "Total : " + result.Character.Percentage[0].Total + "</td></tr>";

//                    res += "<tr style='background-color:#d4d7dc;'><td colspan='2'><b>Line : </b><br> Number : <br> Total : " + result.Line.Number[0].Total + " </td></tr>";

//                    res += "<tr style='background-color:#f1e1e1;'><td><b>Segment :</b><br>Number : <br> ContextMatch : " + result.Segment.Number[0].ContextMatch + "<br>" +
//                        "NoMatch : " + result.Segment.Number[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Segment.Number[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Segment.Number[0].Repetitions + "<br>" +
//                        "Total : " + result.Segment.Number[0].Total + "</td>" +
//                        "<td> <br>Percentage : <br> ContextMatch : " + result.Segment.Percentage[0].ContextMatch + "<br>" +
//                        //"NoMatch : " + result.Segment.Percentage[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Segment.Percentage[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Segment.Percentage[0].Repetitions + "<br>" +
//                        "Total : " + result.Segment.Percentage[0].Total + "</td></tr>";

//                    res += "<tr style='background-color:#d4d7dc;'><td><b>Word :</b><br>Number : <br> ContextMatch : " + result.Word.Number[0].ContextMatch + "<br>" +
//                        "NoMatch : " + result.Word.Number[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Word.Number[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Word.Number[0].Repetitions + "<br>" +
//                        "Total : " + result.Word.Number[0].Total + "</td>" +
//                        "<td> <br>Percentage : <br> ContextMatch : " + result.Word.Percentage[0].ContextMatch + "<br>" +
//                        "NoMatch : " + result.Word.Percentage[0].NoMatch + "<br>" +
//                        "PerfectMatch : " + result.Word.Percentage[0].PerfectMatch + "<br>" +
//                        "Repetitions : " + result.Word.Percentage[0].Repetitions + "<br>" +
//                        "Total : " + result.Word.Percentage[0].Total + "</td></tr></table>";
//                    $("#analyseResult").append(res + "<br> <br>");
//                    $("#continueBtn").css("display", "block");
//                }
                
//                // if success
//                if (data.isSuccess && data.files[0]) {
//                    item.name = data.files[0].name;
//                    item.html.find('.column-title > div:first-child').text(data.files[0].name).attr('title', data.files[0].name);
//                }
//                // if warnings
//                if (data.hasWarnings) {
//                    bootbox.alert({
//                        message: data.warnings,
//                        size: 'small'
//                    });
                    
//                    item.html.removeClass('upload-successful').addClass('upload-failed');
//                    // go out from success function by calling onError function
//                    // in this case we have a animation there
//                    // you can also response in PHP with 404
//                    item.remove();
//                    //return null;
//                    $.loadingBlockHide();
//                    return this.onError ? this.onError(item) : null;
//                }

//                item.html.find('.column-actions').append('<a class="fileuploader-action fileuploader-action-remove fileuploader-action-success" title="Remove"><i></i></a>');
//                setTimeout(function () {
//                    item.html.find('.progress-bar2').fadeOut(400);
//                }, 400);

//                //$(".square").ploading({
//                //    action: 'hide'
//                //});
//                $.loadingBlockHide();
//            },
//            onError: function (item) {
//                var progressBar = item.html.find('.progress-bar2');

//                if (progressBar.length > 0) {
//                    progressBar.find('span').html(0 + "%");
//                    progressBar.find('.fileuploader-progressbar .bar').width(0 + "%");
//                    item.html.find('.progress-bar2').fadeOut(400);
//                }

//                item.upload.status != 'cancelled' && item.html.find('.fileuploader-action-retry').length == 0 ? item.html.find('.column-actions').prepend(
//                    '<a class="fileuploader-action fileuploader-action-retry" title="Retry"><i></i></a>'
//                ) : null;
//            },
//            onProgress: function (data, item) {
//                var progressBar = item.html.find('.progress-bar2');

//                if (progressBar.length > 0) {
//                    progressBar.show();
//                    progressBar.find('span').html(data.percentage + "%");
//                    progressBar.find('.fileuploader-progressbar .bar').width(data.percentage + "%");
//                }
//            },
//            onComplete: null,
//        },
//        onRemove: function (item) {
//            $.post('RemoveFileHandler.ashx?file=' + item.name, {
//                file: item.name
//            });
//        },

//        captions: {
//            feedback: 'Drag and drop files here',
//            feedback2: 'Drag and drop files here',
//            drop: 'Drag and drop files here'
//        },
//    });

//});