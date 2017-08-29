<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FileUploader._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .fileuploader {
            border: 1px solid gainsboro;
        }

        .bg-area {
            padding: 190px 0;
            background: #f2f4f7;
        }

            .bg-area h2 {
                font-weight: bold;
            }

            .bg-area p {
                margin: 20px 0;
            }

        .modal-dialog {
            margin: 0px !important;
        }

        td {
            padding: 15px;
        }

        .piano-spinner { /*,.piano-spinner:before, .piano-spinner:after*/
            position: fixed !important;
            margin-left: 50%;
        }
    </style>

    <div class="bg-area">
        <div class="container">
            <div class="row">
                <div class="col-md-6 col-md-offset-3 text-center">
                    <asp:HiddenField ID="setExtensions" runat="server" />
                    <asp:HiddenField ID="setSize" runat="server" />

                    <asp:TextBox ID="f_Names" runat="server" CssClass="hiddenFileNames"></asp:TextBox>
                    <%--<asp:HiddenField ID="f_Names" runat="server" CssClass="hiddenFileNames"/>--%>
                    <h2 style="color: #5a6170;">Cool, yeah?</h2>
                    <div class="text">
                        <p style="color: #9b9da2;">Here is the default example of Fileuploader plugin. Just try it.</p>
                    </div>
                    <input type="file" name="files" id="files">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 col-md-offset-3">
                    <input type="button" id="continueBtn" value="Continue" onclick="AnalyseResult();" class="btn btn-primary" style="display: none; margin-top: 20px; margin-bottom: 20px;" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 col-md-offset-3" id="analyseResult" style="display: none; margin-top: 20px; margin-bottom: 20px;">
                </div>
            </div>
        </div>
    </div>
    <asp:TextBox ID="setExtensions_" runat="server" CssClass="setExtensions_"></asp:TextBox>
    <asp:TextBox ID="setSize_" runat="server" CssClass="setSize_"></asp:TextBox>
    <script>
        $(".setExtensions_").hide();
        $(".setSize_").hide();
        $(".hiddenFileNames").hide();
        <%--var _extension = $("#<%= setExtensions_.ClientID %>").val();--%>
        function AnalyseResult() {
            var f_names = $(".hiddenFileNames").val();
            $.loadingBlockShow({
                imgPath: 'SpinnerLoaderWithText/assets/img/default.svg',
                imgStyle: {
                    width: 'auto',
                    textAlign: 'center',
                    marginTop: '20%'
                },
                text: "Please wait while we're analysing your files......"
            });
            $.ajax({
                type: "POST",
                data: {},
                url: "FileAnalyseHandler.ashx?names=" + f_names,
                contentType: "application/json",
                datatype: "json",
                async: true,
                success: function (response) {
                    var result = JSON.parse(response);
                    console.log(result);
                    debugger;
                    if (result.ErrorMessage != null && result.ErrorMessage != "" && result.ErrorMessage != undefined) {
                        alert(result.ErrorMessage);
                        $.loadingBlockHide();
                    }
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
                        "NoMatch : " + result.Segment.Percentage[0].NoMatch + "<br>" +
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

                    $("#analyseResult").empty();
                    $("#analyseResult").append(res);
                    //alert("You can also see Results in console.");
                    $("#analyseResult").css("display", "block");
                    $.loadingBlockHide();
                },
                error: function (err) {
                    alert(err.statusText);
                    $.loadingBlockHide();
                },
                failure: function (fail) {
                    $.loadingBlockHide();
                }
            });    
            
        }
    </script>
</asp:Content>

