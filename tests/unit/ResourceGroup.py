import terraform_validate
import unittest2
import os

class ResourceGroup(unittest2.TestCase):
    def setUp(self):
        scriptDir = os.path.dirname(os.path.abspath(__file__))
        hclPath = os.path.join(scriptDir, '../..')
        self.hcl = terraform_validate.Validator(hclPath)
        self.rg = self.hcl.resources('azurerm_resource_group')
    def test_itContainsProperties(self):
        self.rg.should_have_properties(['name', 'location'])
    def test_itIsInUnitedKingdomSouth(self):
        self.rg.property('location').should_equal('UK South')

if __name__ == '__main__':
    unittest2.main()
