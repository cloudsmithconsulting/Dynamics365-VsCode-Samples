﻿using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Dynamics365.UIAutomation.Api;
using Microsoft.Dynamics365.UIAutomation.Browser;

namespace CloudSmith.Dynamics365.SampleTests
{
    [TestClass]
    public class InteractiveBrowserTests
    {
        private static readonly string _crmServerUri = "http://crmserver/test";

        [TestMethod]
        public void OpenAccountsGrid()
        {
            using (var browser = new Browser(new BrowserOptions { BrowserType = BrowserType.Chrome }))
            {
                browser.GoToXrmUri(new System.Uri(_crmServerUri));
                browser.GuidedHelp.CloseGuidedHelp();
                browser.Navigation.OpenSubArea("Sales", "Accounts");
                browser.Grid.SwitchView("All Accounts");
            }
        }

        [TestMethod]
        public void SwitchDashboard()
        {
            using (var browser = new Browser(new BrowserOptions { BrowserType = BrowserType.IE }))
            {
                browser.GoToXrmUri(new System.Uri(_crmServerUri));
                browser.Dashboard.SelectDashBoard("Microsoft Dynamics 365 Overview");
            }
        }
    }
}
