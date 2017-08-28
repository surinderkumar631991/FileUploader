using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FileUploader
{
    /// <summary>
    /// Summary description for RemoveFileHandler
    /// </summary>
    public class RemoveFileHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            _Default obj = new _Default();
            var _pathname = obj.getPath();
            var file= context.Request["file"];
            string fileName = HttpContext.Current.Server.MapPath(_pathname + "/" + file);
            if ((System.IO.File.Exists(fileName)))
            {
                System.IO.File.Delete(fileName);
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}