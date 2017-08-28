<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebForm2.aspx.cs" Inherits="FileUploader.WebForm2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">


    <%--<script src="http://code.jquery.com/jquery-3.1.1.slim.min.js"></script>--%>
    <%--<script src="SpinnerLoaderWithText/assets/js/jquery.loading.block.js"></script>--%>

    <input type="file" id="files" multiple />
    <input type="button" onclick="apiCall();" value="File" />
    <div id="AnalyseResult"></div>
    <script>

        function apiCall() {
            //$.loadingBlockShow({
            //    imgPath: 'SpinnerLoaderWithText/assets/img/default.svg',
            //    imgStyle: {
            //        width: 'auto',
            //        textAlign: 'center',
            //        marginTop: '20%'
            //    },
            //    text: 'Please Wait...'
            //});
            $(".square").ploading({
                action: 'show',
                spinner: 'wave'
            });

            var file = $("#files")[0].files;
            if (file.length > 0) {

                var fileData = new FormData();
                for (var i = 0; i < file.length; i++) {
                    var f = file[i];
                    fileData.append(file[i].name, file[i]);
                }

                $.ajax({
                    type: "POST",
                    data: fileData,
                    url: "http://localhost:9832/analyse",
                    contentType: "application/json",
                    contentType: false,
                    processData: false,
                    datatype: "json",
                    success: function (result) {
                        console.log(result);

                        var res = "<table style='width:100%;'><tr style='background-color:#f1e1e1;'><td><b>Character :</b><br>Number : <br> ContextMatch : " + result.Character.Number[0].ContextMatch + "<br>" +
                            "NoMatch : " + result.Character.Number[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Character.Number[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Character.Number[0].Repetitions + "<br>" +
                            "Total : " + result.Character.Number[0].Total + "</td>" +
                            "<td> <br>Percentage : <br> ContextMatch : " + result.Character.Percentage[0].ContextMatch + "<br>" +
                            "NoMatch : " + result.Character.Percentage[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Character.Percentage[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Character.Percentage[0].Repetitions + "<br>" +
                            "Total : " + result.Character.Percentage[0].Total + "</td></tr>";

                        res += "<tr style='background-color:#d4d7dc;'><td colspan='2'><b>Line : </b><br> Number : <br> Total : " + result.Line.Number[0].Total + " </td></tr>";

                        res += "<tr style='background-color:#f1e1e1;'><td><b>Segment :</b><br>Number : <br> ContextMatch : " + result.Segment.Number[0].ContextMatch + "<br>" +
                            "NoMatch : " + result.Segment.Number[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Segment.Number[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Segment.Number[0].Repetitions + "<br>" +
                            "Total : " + result.Segment.Number[0].Total + "</td>" +
                            "<td> <br>Percentage : <br> ContextMatch : " + result.Segment.Percentage[0].ContextMatch + "<br>" +
                            //"NoMatch : " + result.Segment.Percentage[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Segment.Percentage[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Segment.Percentage[0].Repetitions + "<br>" +
                            "Total : " + result.Segment.Percentage[0].Total + "</td></tr>";

                        res += "<tr style='background-color:#d4d7dc;'><td><b>Word :</b><br>Number : <br> ContextMatch : " + result.Word.Number[0].ContextMatch + "<br>" +
                            "NoMatch : " + result.Word.Number[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Word.Number[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Word.Number[0].Repetitions + "<br>" +
                            "Total : " + result.Word.Number[0].Total + "</td>" +
                            "<td> <br>Percentage : <br> ContextMatch : " + result.Word.Percentage[0].ContextMatch + "<br>" +
                            "NoMatch : " + result.Word.Percentage[0].NoMatch + "<br>" +
                            "PerfectMatch : " + result.Word.Percentage[0].PerfectMatch + "<br>" +
                            "Repetitions : " + result.Word.Percentage[0].Repetitions + "<br>" +
                            "Total : " + result.Word.Percentage[0].Total + "</td></tr></table>";

                        $("#AnalyseResult").empty();
                        $("#AnalyseResult").append(res);
                        //alert("You can also see Results in console.");
                        $(".square").ploading({
                            action: 'hide'
                        });
                    },
                    error: function (err) {
                        alert(err.status);
                        $(".square").ploading({
                            action: 'hide'
                        });
                    }
                });

            }

            else {
                alert("Select file.");
                $(".square").ploading({
                    action: 'hide'
                });
            }

        }

    </script>

</asp:Content>
