using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(FileUploader.Startup))]
namespace FileUploader
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
