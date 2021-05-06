/// <reference types='cypress' />

describe('Home', () => {
    it('should visit home page', function () {
        cy.visit('/');
        cy.url().should('include', 'localhost');
    });
});