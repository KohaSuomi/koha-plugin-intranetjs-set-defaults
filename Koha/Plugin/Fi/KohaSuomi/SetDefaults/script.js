var param_a = REPLACE_BY_CONFIG_PARAM_A;
var param_b = REPLACE_BY_CONFIG_PARAM_B;
var param_c = REPLACE_BY_CONFIG_PARAM_C;
var param_d = REPLACE_BY_CONFIG_PARAM_D;

console.log("param_c");
console.log(param_c);


/// ALKU ///
/* Laita raksi "Poista käsin poistettujen varausten maksut" -kohtaa palautuksessa. Tällä estetään noutamattoman varauksen maksun syntyminen, kun varaus noudettavissa oleva varaus poistetaan palautuksen kautta. Huom! Ei toimi, jos palautus tehdään muualla kuin Palautus-sivulla. */
$(document).ready(function () {
    if (param_a == 1){
    $("#forgivemanualholdsexpire").attr('checked', true);
}
});
/// LOPPU ///



/// ALKU ///
//Asiakkaalle lähtevien ilmoitusten oletuskielivalinta suomeksi
$(document).ready(function () {
    if (param_b == 1){
    if (window.location.href.indexOf("members/memberentry.pl") > -1) {
        var $notices_lang_select = document.querySelector('#lang');
        var selected = $notices_lang_select.value;
        if (selected == 'default') {
            $notices_lang_select.value = 'fi-FI';
        }
    }
}
});
/// LOPPU ///



/// ALKU ///
/* Laita niteiden eräpoistossa täppä kohtaan "Poista tietueet, jos kaikki niteet poistettu". Tällä varmistetaan, että tietokantaan ei jää niteettömiä tietueita. */
$(document).ready(function () {
    if (param_c == 1){
    $("#del_records").attr('checked', true);
}
});
/// LOPPU ///



/// ALKU ///
//Kausijulkaisujen vastaanoton oletuskirjastoksi kirjautumiskirjasto
$(document).ready(function () {
    if (param_d == "1"){
    if (window.location.href.indexOf("serials/serials-home.pl") > -1) {
        var textToFind = $('.logged-in-branch-code:first').text();
        $('#branch').val(textToFind);
        $('#branch').change();
    }
}
});
///LOPPU///
