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
        td{
            padding:15px;
        }
        .piano-spinner{                 /*,.piano-spinner:before, .piano-spinner:after*/
            position:fixed !important;
            margin-left: 50%;
        }
    </style>

    <div class="bg-area">
        <div class="container">
            <div class="row">
                <div class="col-md-6 col-md-offset-3 text-center">
                    <asp:HiddenField ID="setExtensions" runat="server" />
                    <asp:HiddenField ID="setSize" runat="server" />
                    <h2 style="color: #5a6170;">Cool, yeah?</h2>
                    <div class="text">
                        <p style="color: #9b9da2;">Here is the default example of Fileuploader plugin. Just try it.</p>
                    </div>
                    <input type="file" name="files" id="files">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 col-md-offset-3">
                    <input type="button" id="continueBtn" value="Continue" onclick="AnalyseResult();" class="btn btn-primary" style="display:none;margin-top:20px;margin-bottom:20px;"/>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 col-md-offset-3" id="analyseResult" style="display:none;margin-top:20px;margin-bottom:20px;">
                </div>
            </div>
        </div>
    </div>
    <asp:TextBox ID="setExtensions_" runat="server" CssClass="setExtensions_"></asp:TextBox>
    <asp:TextBox ID="setSize_"  runat="server" CssClass="setSize_"></asp:TextBox>
    <script>
        $(".setExtensions_").hide();
        $(".setSize_").hide();
        <%--var _extension = $("#<%= setExtensions_.ClientID %>").val();--%>
        function AnalyseResult() {
            $("#analyseResult").css("display", "block");
        }
    </script>
</asp:Content>

