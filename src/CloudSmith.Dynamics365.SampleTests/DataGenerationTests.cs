using Bogus;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Tooling.Connector;
using System;

namespace CloudSmith.Dynamics365.SampleTests
{
    [TestClass]
    public class DataGenerationTests
    {
        //TODO: update this connection string with your username and password where it says {username} and {password} below.
        private static readonly string _connectionString = "AuthType=AD;ServiceUri=http://crmserver/test;Domain=contoso.local;UserName={username};Password={password}";

        // For more information on Bogus, see: https://github.com/bchavez/Bogus
        private static readonly Faker<Account> _accountGenerator = new Faker<Account>()
            .RuleFor(a => a.Name, s => s.Company.CompanyName())
            .RuleFor(a => a.EMailAddress1, s => s.Internet.Email())
            .RuleFor(a => a.CreditOnHold, b => b.Random.Bool())
            .RuleFor(a => a.LastOnHoldTime, d => d.Date.Between(DateTime.Now.AddYears(-1), DateTime.Now))
            .RuleFor(a => a.Address1_Line1, s => s.Address.StreetAddress())
            .RuleFor(a => a.Address1_City, s => s.Address.City())
            .RuleFor(a => a.Address1_StateOrProvince, s => s.Address.StateAbbr())
            .RuleFor(a => a.Address1_PostalCode, s => s.Address.ZipCode())
            .RuleFor(a => a.Address1_Telephone1, s => s.Phone.PhoneNumber())
            .RuleFor(a => a.NumberOfEmployees, i => i.Random.Number(1, 50000))
            .RuleFor(a => a.Revenue, d => new Money(d.Random.Number(100000, 100000000)))
            .RuleFor(a => a.Telephone1, s => s.Phone.PhoneNumber())
            .RuleFor(a => a.WebSiteURL, s => s.Internet.Url())
            .RuleFor(a => a.TickerSymbol, s => s.Hacker.Abbreviation());

        // For more information on Bogus, see: https://github.com/bchavez/Bogus
        private static readonly Faker<Contact> _contactGenerator = new Faker<Contact>()
            .RuleFor(c => c.FirstName, s => s.Name.FirstName())
            .RuleFor(c => c.LastName, s => s.Name.LastName())
            .RuleFor(c => c.EMailAddress1, s => s.Internet.Email())
            .RuleFor(c => c.Telephone1, s => s.Phone.PhoneNumber())
            .RuleFor(c => c.Suffix, s => s.Name.Suffix())
            .RuleFor(c => c.JobTitle, s => s.Name.JobTitle())
            .RuleFor(c => c.WebSiteUrl, s => s.Internet.Url());

        [TestMethod]
        public void GenerateHardCodedAccount()
        {
            using (var client = new CrmServiceClient(_connectionString))
            {
                var account = new Account()
                {
                    Name = "Acme Industries, Ltd",
                    EMailAddress1 = "sales@acmeindustries.com",
                    CreditOnHold = false,
                    LastOnHoldTime = DateTime.Now.AddYears(-1),
                    Address1_Line1 = "1234 Acme Road",
                    Address1_Line2 = "Suite 123",
                    Address1_City = "Acme",
                    Address1_StateOrProvince = "AC",
                    Address1_PostalCode = "01234",
                    NumberOfEmployees = 10,
                    Revenue = new Money(1000000),
                    Telephone1 = "(123) 456-7890",
                    WebSiteURL = "http://www.acmeindustries.com",
                    TickerSymbol = "ACME"
                };

                // Create the account
                Guid accountId = client.Create(account);
                Assert.IsTrue(accountId != Guid.Empty);
            }
        }

        [TestMethod]
        public void GenerateRandomAccounts()
        {
            using (var client = new CrmServiceClient(_connectionString))
            {
                var accounts = _accountGenerator.Generate(10);

                accounts.ForEach(account =>
                {
                    // Create the account
                    Guid accountId = client.Create(account);
                    Assert.IsTrue(accountId != Guid.Empty);
                });
            }
        }

        [TestMethod]
        public void GenerateRandomAccountsWithContacts()
        {
            using (var client = new CrmServiceClient(_connectionString))
            {
                var contacts = _contactGenerator.Generate(10);

                contacts.ForEach(contact =>
                {
                    // Create the contact
                    Guid contactId = client.Create(contact);
                    Assert.IsTrue(contactId != Guid.Empty);

                    // Generate an account
                    Account account = _accountGenerator.Generate(1)[0];

                    // Assign the primary contact ID
                    account.PrimaryContactId = new EntityReference(contact.LogicalName, contactId);

                    // Create the account
                    Guid accountId = client.Create(account);
                    Assert.IsTrue(accountId != Guid.Empty);
                });
            }
        }

    }
}
