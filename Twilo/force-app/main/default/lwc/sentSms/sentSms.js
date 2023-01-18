import { LightningElement, api } from 'lwc';
import sentSmsToCustomerMethod from '@salesforce/apex/SentSmsController.sentSmsToCustomer';

export default class SentSms extends LightningElement {
    @api recordId;
    sentTwiloSms(event) {
        console.log('in sentTwiloSms');
        var inp = this.template.querySelector("lightning-input");

        sentSmsToCustomerMethod({smsBody: inp.value, accountId: this.recordId}).then(result => {
        })
        .catch(error => {
        });
    }
}